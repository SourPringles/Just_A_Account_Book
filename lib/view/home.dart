import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'auth/login.dart';
import 'auth/auth.dart';
import 'calendar/calendar_widget.dart';
import 'transactions/add_transaction_dialog.dart';
import 'transactions/monthly_summary_widget.dart';
import 'transactions/transaction_list_widget.dart';

//TEST VALUE
int currentMonth = 9;
int monthIncome = 00000;
int monthExpense = 00000;
int weeklyTotal = 00000;
int monthlyTotal = 00000;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  int _currentIndex = 0;

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
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddTransactionDialog(context),
              child: const Icon(Icons.add),
            ),
            bottomNavigationBar: BottomNavigationBar(
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
                BottomNavigationBarItem(icon: Icon(Icons.list), label: '거래내역'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: '요약',
                ),
              ],
            ),
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
    final isWideScreen = constraints.maxWidth > 800;
    final isMediumScreen = constraints.maxWidth > 600;

    if (isWideScreen) {
      return _buildWideScreenLayout(user);
    } else if (isMediumScreen) {
      return _buildMediumScreenLayout(user);
    } else {
      return _buildNarrowScreenLayout(user);
    }
  }

  Widget _buildWideScreenLayout(User? user) {
    return _buildNarrowScreenLayout(user);
  }

  Widget _buildMediumScreenLayout(User? user) {
    return _buildNarrowScreenLayout(user);
  }

  Widget _buildNarrowScreenLayout(User? user) {
    switch (_currentIndex) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CalendarWidget(
                initialSelectedDate: _selectedDate,
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
        // 상태를 업데이트하여 StreamBuilder가 다시 빌드되도록 함
      });
    }
  }
}
