import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'uivalue.dart';

import '../services/auth_service.dart';
import '../services/theme_service.dart';
import 'auth/login.dart';
import 'auth/auth.dart';
import 'calendar/calendar_widget.dart';
import 'transactions/add_transaction_dialog.dart';
import 'transactions/monthly_summary_widget.dart';
import 'transactions/transaction_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  int _rightPanelIndex = 0; // 윈도우 레이아웃 우측 패널 인덱스 (0: 거래내역, 1: 요약)
  int _refreshTrigger = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext con, AsyncSnapshot<User?> user) {
        if (!user.hasData) {
          return const LoginPage();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('가계부'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _showAccountInfoDialog(context, user.data),
                ),
                // 설정 페이지로 이동하는 버튼
                IconButton(
                  icon: const Icon(Icons.tune),
                  tooltip: '설정',
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await AuthService.signOut();
                    if (context.mounted) {
                      Navigator.pushNamed(context, "/login");
                    }
                  },
                ),
              ],
            ),
            body: _buildWindowScreenLayout(user.data),
          );
        }
      },
    );
  }

  Widget _buildWindowScreenLayout(User? user) {
    return Row(
      children: [
        // 좌측 - 캘린더
        Expanded(child: _buildLeftPanel()),
        // 우측 - 거래내역/요약
        Expanded(child: _buildRightPanel(user)),
      ],
    );
  }

  // 좌측 패널 - 캘린더
  Widget _buildLeftPanel() {
    // Column을 사용해 캘린더를 항상 위쪽에 고정(sticky)하도록 배치.
    // 캘린더 아래로 확장 가능한 빈 공간을 둬서 창 크기가 변해도 최상단에 머물게 함.
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey.shade300,
            width: UIValue.borderWidthNormal,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(UIValue.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 캘린더를 최상단에 고정
            CalendarWidget(
              initialSelectedDate: _selectedDate,
              refreshTrigger: _refreshTrigger,
              uiType: CalendarUIType.window,
              onDateSelected: (date) {
                // 우측 패널이 요약 탭일 때는 리빌드하지 않음
                if (_rightPanelIndex == 1) {
                  _selectedDate = date;
                } else {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
            // 아래에 남는 공간은 확장하여 캘린더가 항상 위에 머물도록 함.
            SizedBox(height: UIValue.smallGap),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  // 우측 패널 - 거래내역/요약 전환
  Widget _buildRightPanel(User? user) {
    return Column(
      children: [
        _buildRightPanelTabs(),
        Expanded(child: _buildRightPanelContent(user)),
      ],
    );
  }

  // 우측 패널 탭 버튼들
  Widget _buildRightPanelTabs() {
    return Container(
      padding: EdgeInsets.all(UIValue.smallGap),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: UIValue.borderWidthNormal,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(index: 0, label: '거래내역', icon: Icons.list),
          ),
          SizedBox(width: UIValue.smallGap),
          Expanded(
            child: _buildTabButton(
              index: 1,
              label: '요약',
              icon: Icons.analytics,
            ),
          ),
        ],
      ),
    );
  }

  // 탭 버튼 위젯
  Widget _buildTabButton({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _rightPanelIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _rightPanelIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: UIValue.smallGap,
          horizontal: UIValue.smallGap,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: UIValue.iconSizeSmall,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : (() {
                      final c = Theme.of(context).colorScheme.onSurface;
                      final r = (c.r * 255.0).round() & 0xff;
                      final g = (c.g * 255.0).round() & 0xff;
                      final b = (c.b * 255.0).round() & 0xff;
                      return Color.fromRGBO(r, g, b, 0.7);
                    })(),
            ),
            SizedBox(width: UIValue.tinyGap),
            Text(
              label,
              style: UIValue.subtitleStyle(
                context,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : (() {
                        final c = Theme.of(context).colorScheme.onSurface;
                        final r = (c.r * 255.0).round() & 0xff;
                        final g = (c.g * 255.0).round() & 0xff;
                        final b = (c.b * 255.0).round() & 0xff;
                        return Color.fromRGBO(r, g, b, 0.8);
                      })(),
                weight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 우측 패널 컨텐츠
  Widget _buildRightPanelContent(User? user) {
    switch (_rightPanelIndex) {
      case 0: // 거래내역
        return _buildTransactionPanel();
      case 1: // 요약
        return _buildSummaryPanel();
      default:
        return _buildTransactionPanel();
    }
  }

  // 거래내역 패널
  Widget _buildTransactionPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTransactionHeader(),
        Expanded(
          child: TransactionListWidget(
            selectedDate: _selectedDate,
            showDailyOnly: true,
          ),
        ),
      ],
    );
  }

  // 거래내역 헤더
  Widget _buildTransactionHeader() {
    return Container(
      padding: EdgeInsets.all(UIValue.defaultPadding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: UIValue.borderWidthNormal,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long,
            color: Colors.blue,
            size: UIValue.iconSizeXL / 2.666,
          ),
          SizedBox(width: UIValue.smallGap),
          Text(
            '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
            style: UIValue.titleStyle(context),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => _showAddTransactionDialog(context),
            icon: Icon(Icons.add, size: UIValue.iconSizeSmall),
            label: const Text('거래 추가'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: UIValue.smallGap * 2,
                vertical: UIValue.smallGap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 요약 패널
  Widget _buildSummaryPanel() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(UIValue.defaultPadding),
          child: MonthlySummaryWidget(month: _selectedDate),
        ),
        SizedBox(height: UIValue.largeGap),
        Expanded(
          child: TransactionListWidget(
            selectedDate: _selectedDate,
            showDailyOnly: false,
          ),
        ),
      ],
    );
  }

  // 계정 정보 다이얼로그
  void _showAccountInfoDialog(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(UIValue.dialogPadding),
            constraints: BoxConstraints(
              maxWidth: UIValue.dialogMaxWidth,
              maxHeight: UIValue.dialogMaxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogHeader(context),
                const Divider(),
                SizedBox(height: UIValue.largeGap),
                Flexible(
                  child: SingleChildScrollView(child: AuthWidget(user: user)),
                ),
                SizedBox(height: UIValue.largeGap),
                _buildDialogFooter(context),
              ],
            ),
          ),
        );
      },
    );
  }

  // 다크/라이트/시스템 테마 선택 다이얼로그
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final current = ThemeService.instance.themeMode.value;
        return AlertDialog(
          title: const Text('테마 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: current,
                title: const Text('시스템 기본'),
                onChanged: (v) async {
                  if (v != null) {
                    final nav = Navigator.of(ctx);
                    await ThemeService.instance.setThemeMode(v);
                    nav.pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: current,
                title: const Text('라이트'),
                onChanged: (v) async {
                  if (v != null) {
                    final nav = Navigator.of(ctx);
                    await ThemeService.instance.setThemeMode(v);
                    nav.pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: current,
                title: const Text('다크'),
                onChanged: (v) async {
                  if (v != null) {
                    final nav = Navigator.of(ctx);
                    await ThemeService.instance.setThemeMode(v);
                    nav.pop();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  // 다이얼로그 헤더
  Widget _buildDialogHeader(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text(
            "계정 정보",
            style: TextStyle(
              fontSize: UIValue.titleFontSize(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: -8,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            splashRadius: 20,
          ),
        ),
      ],
    );
  }

  // 다이얼로그 푸터
  Widget _buildDialogFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("닫기"),
        ),
      ],
    );
  }

  // 거래 추가 다이얼로그
  Future<void> _showAddTransactionDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddTransactionDialog(initialDate: _selectedDate),
    );

    if (result == true && mounted) {
      setState(() {
        _refreshTrigger++;
      });
    }
  }
}
