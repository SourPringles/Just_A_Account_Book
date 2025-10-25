import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CalendarWidget(
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(index: 0, label: '거래내역', icon: Icons.list),
          ),
          const SizedBox(width: 8),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, color: Colors.blue, size: 24),
          const SizedBox(width: 8),
          Text(
            '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => _showAddTransactionDialog(context),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('거래 추가'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          padding: const EdgeInsets.all(16),
          child: MonthlySummaryWidget(month: _selectedDate),
        ),
        const SizedBox(height: 16),
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
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogHeader(context),
                const Divider(),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(child: AuthWidget(user: user)),
                ),
                const SizedBox(height: 16),
                _buildDialogFooter(context),
              ],
            ),
          ),
        );
      },
    );
  }

  // 다이얼로그 헤더
  Widget _buildDialogHeader(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Text(
            "계정 정보",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
