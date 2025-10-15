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
  int _currentIndex = 0;
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
            body: LayoutBuilder(
              builder: (context, constraints) {
                return _buildResponsiveBody(context, user.data, constraints);
              },
            ),
            floatingActionButton: MediaQuery.of(context).size.width <= 600
                ? FloatingActionButton(
                    onPressed: () => _showAddTransactionDialog(context),
                    child: const Icon(Icons.add),
                  )
                : null,
            bottomNavigationBar: MediaQuery.of(context).size.width <= 600
                ? BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today),
                        label: '캘린더',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.list),
                        label: '거래내역',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.analytics),
                        label: '요약',
                      ),
                    ],
                  )
                : null,
          );
        }
      },
    );
  }

  Widget _buildResponsiveBody(
    BuildContext context,
    User? user,
    BoxConstraints constraints,
  ) {
    final isDevMod = false; // 개발 모드 플래그 - 개발용 레이아웃 활성화
    final isMediumScreen = constraints.maxWidth > 800;

    if (isDevMod == true) {
      return _buildDevScreenLayout(user);
    }

    if (isMediumScreen) {
      return _buildWindowScreenLayout(user);
    } else {
      return _buildMobileScreenLayout(user);
    }
  }

  Widget _buildDevScreenLayout(User? user) {
    return Row(
      children: [
        // 좌측: 윈도우 레이아웃 (1280x720 비율로 스케일)
        Expanded(
          flex: 1280, // 윈도우 레이아웃 비율
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade300, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                // 윈도우 레이아웃 헤더
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.desktop_windows,
                        color: Colors.blue.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Window Layout (1280x720)',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // 윈도우 레이아웃 컨텐츠 (dev 모드에서는 크기 축소)
                Expanded(child: _buildWindowScreenLayoutForDev(user)),
              ],
            ),
          ),
        ),

        // 우측: 모바일 레이아웃 (480x1000 비율로 스케일)
        Expanded(
          flex: 480, // 모바일 레이아웃 비율
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green.shade300, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                // 모바일 레이아웃 헤더
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_android,
                        color: Colors.green.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Mobile Layout (480x1000)',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // 모바일 레이아웃 컨텐츠
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: _buildMobileScreenLayoutForDev(user)),
                      // 모바일용 하단 네비게이션 시뮬레이션
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMobileNavItem(0, '캘린더', Icons.calendar_today),
                            _buildMobileNavItem(1, '거래내역', Icons.list),
                            _buildMobileNavItem(2, '요약', Icons.analytics),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 모바일 네비게이션 아이템 위젯
  Widget _buildMobileNavItem(int index, String label, IconData icon) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.blue : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 개발 모드용 윈도우 레이아웃 (작은 텍스트 사용)
  Widget _buildWindowScreenLayoutForDev(User? user) {
    return Row(
      children: [
        // 좌측 절반 - 모바일 레이아웃
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: _buildLeftPanel(user, uiType: CalendarUIType.dev),
          ),
        ),
        // 우측 절반 - 선택한 날짜의 거래 내역
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: _buildRightPanel(user),
          ),
        ),
      ],
    );
  }

  Widget _buildWindowScreenLayout(User? user) {
    return Row(
      children: [
        // 좌측 절반 - 모바일 레이아웃
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: _buildLeftPanel(user, uiType: CalendarUIType.window),
          ),
        ),
        // 우측 절반 - 선택한 날짜의 거래 내역
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: _buildRightPanel(user),
          ),
        ),
      ],
    );
  }

  // 좌측 패널 (모바일 레이아웃과 동일하지만 하단 네비게이션 없음)
  Widget _buildLeftPanel(User? user, {CalendarUIType? uiType}) {
    return Column(
      children: [
        // 탭 버튼들
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(child: _buildTabButton(0, '캘린더', Icons.calendar_today)),
              const SizedBox(width: 8),
              Expanded(child: _buildTabButton(1, '거래내역', Icons.list)),
              const SizedBox(width: 8),
              Expanded(child: _buildTabButton(2, '요약', Icons.analytics)),
            ],
          ),
        ),
        // 컨텐츠 영역
        Expanded(
          child: _buildTabContent(
            user,
            uiType: uiType ?? CalendarUIType.window,
          ),
        ),
      ],
    );
  }

  // 탭 버튼 위젯
  Widget _buildTabButton(int index, String label, IconData icon) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
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

  // 탭 컨텐츠
  Widget _buildTabContent(User? user, {CalendarUIType? uiType}) {
    switch (_currentIndex) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CalendarWidget(
                initialSelectedDate: _selectedDate,
                refreshTrigger: _refreshTrigger,
                uiType: uiType,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ],
          ),
        );
      case 1:
        return Column(
          children: [
            Expanded(
              child: TransactionListWidget(
                selectedDate: _selectedDate,
                showDailyOnly: false,
              ),
            ),
          ],
        );
      case 2:
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
                showDailyOnly: true,
              ),
            ),
          ],
        );
      default:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [CalendarWidget()]),
        );
    }
  }

  // 우측 패널 - 선택한 날짜의 거래 내역
  Widget _buildRightPanel(User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Container(
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              Text(
                '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddTransactionDialog(context),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('거래 추가'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 거래 내역 리스트
        Expanded(
          child: TransactionListWidget(
            selectedDate: _selectedDate,
            showDailyOnly: true,
          ),
        ),
      ],
    );
  }

  // 개발 모드용 모바일 레이아웃 (작은 텍스트 사용)
  Widget _buildMobileScreenLayoutForDev(User? user) {
    switch (_currentIndex) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CalendarWidget(
                initialSelectedDate: _selectedDate,
                refreshTrigger: _refreshTrigger,
                uiType: CalendarUIType.dev, // dev 타입 사용
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ],
          ),
        );
      case 1:
        return Column(
          children: [
            Expanded(
              child: TransactionListWidget(
                selectedDate: _selectedDate,
                showDailyOnly: false,
              ),
            ),
          ],
        );
      case 2:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              MonthlySummaryWidget(month: _selectedDate),
              const SizedBox(height: 16),
              TransactionListWidget(
                selectedDate: _selectedDate,
                showDailyOnly: true,
              ),
            ],
          ),
        );
      default:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [CalendarWidget(uiType: CalendarUIType.dev)]),
        );
    }
  }

  Widget _buildMobileScreenLayout(User? user) {
    switch (_currentIndex) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CalendarWidget(
                initialSelectedDate: _selectedDate,
                refreshTrigger: _refreshTrigger,
                uiType: CalendarUIType.mobile,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ],
          ),
        );
      case 1:
        return Column(
          children: [
            Expanded(
              child: TransactionListWidget(
                selectedDate: _selectedDate,
                showDailyOnly: false,
              ),
            ),
          ],
        );
      case 2:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              MonthlySummaryWidget(month: _selectedDate),
              const SizedBox(height: 16),
              TransactionListWidget(
                selectedDate: _selectedDate,
                showDailyOnly: true,
              ),
            ],
          ),
        );
      default:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [CalendarWidget()]),
        );
    }
  }

  void _showAccountInfoDialog(BuildContext context, User? user) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogPadding = screenWidth < 400 ? 16.0 : 24.0;
    final titleFontSize = screenWidth < 400 ? 16.0 : 20.0;
    final maxDialogWidth = screenWidth < 500 ? screenWidth * 0.9 : 400.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(dialogPadding),
            constraints: BoxConstraints(
              maxWidth: maxDialogWidth,
              maxHeight: screenWidth < 400 ? 600 : 500,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // 중앙 정렬된 제목
                    Center(
                      child: Text(
                        "Account Information",
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // 우상단 닫기 버튼
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
                ),
                const Divider(),
                SizedBox(height: screenWidth < 400 ? 12 : 16),
                Flexible(
                  child: SingleChildScrollView(child: AuthWidget(user: user)),
                ),
                SizedBox(height: screenWidth < 400 ? 12 : 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          fontSize: screenWidth < 400 ? 14.0 : 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddTransactionDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AddTransactionDialog(initialDate: _selectedDate);
      },
    );

    // 거래가 성공적으로 추가되면 화면을 새로고침
    if (result == true) {
      setState(() {
        // 캘린더 새로고침 트리거
        _refreshTrigger++;
      });
    }
  }
}
