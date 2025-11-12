import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../uivalue/ui_layout.dart';

import '../calendar/calendar_page.dart';
import '../transactions/add_transaction_dialog.dart';

import '../../services/auth_service.dart';
import '../auth/login.dart';
import '../auth/auth.dart';
import '../uivalue/ui_colors.dart';
import 'widgets/home_widget_left_panel.dart';
import 'widgets/home_widget_right_panel.dart';
import '../dialog/dialog_header_widget.dart';
import '../dialog/dialog_footer_widget.dart';

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
    // Localization accessed where needed in dialogs/widgets

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext con, AsyncSnapshot<User?> user) {
        if (!user.hasData) {
          return const LoginPage();
        } else {
          // Responsive: use mobile layout for narrow screens
          final width = MediaQuery.of(con).size.width;
          if (width < 600) {
            return _buildMobileScreenLayout(user.data);
          }
          return Scaffold(body: _buildWindowScreenLayout(user.data));
        }
      },
    );
  }

  Widget _buildWindowScreenLayout(User? user) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        // 좌측 - 캘린더
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  UIColors.incomeColor.withAlpha(26),
                  UIColors.expenseColor.withAlpha(26),
                ],
              ),
            ),
            child: Column(
              children: [
                // 버튼 높이와 동일한 여백 (패딩 + 아이콘 크기 + 패딩)
                SizedBox(height: UILayout.defaultPadding * 2 + 24),
                Expanded(
                  child: LeftPanelWidget(
                    selectedDate: _selectedDate,
                    refreshTrigger: _refreshTrigger,
                    rightPanelIndex: _rightPanelIndex,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // removed gap so background gradient flows continuously between panels
        // 우측 - 거래내역/요약
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  // 버튼 높이와 동일한 여백 (패딩 + 아이콘 크기 + 패딩)
                  SizedBox(height: UILayout.defaultPadding * 2 + 24),
                  Expanded(
                    child: RightPanelWidget(
                      key: ValueKey(_refreshTrigger), // 새로고침 트리거
                      selectedDate: _selectedDate,
                      initialIndex: _rightPanelIndex,
                      onIndexChanged: (i) =>
                          setState(() => _rightPanelIndex = i),
                      onTransactionAdded: () =>
                          setState(() => _refreshTrigger++),
                    ),
                  ),
                ],
              ),
              // 우상단 버튼들
              Positioned(
                top: UILayout.defaultPadding,
                right: UILayout.defaultPadding,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: l10n.refresh,
                      onPressed: () {
                        setState(() {
                          _refreshTrigger++;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      tooltip: l10n.accountInfo,
                      onPressed: () => _showAccountInfoDialog(context, user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune),
                      tooltip: l10n.settings,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await AuthService.signOut();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Mobile-friendly layout: Tabbed view with Calendar and Transactions
  Widget _buildMobileScreenLayout(User? user) {
    final l10n = AppLocalizations.of(context)!;
    // compute scaled sizes for tab bar icons and labels (2/3 of defaults)
    final double _baseIconSize = IconTheme.of(context).size ?? 24.0;
    final double _baseLabelSize =
        Theme.of(context).textTheme.bodySmall?.fontSize ?? 12.0;
    final double _tabIconSize = _baseIconSize * (2 / 3);
    final double _tabLabelSize = _baseLabelSize * (2 / 3);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight * 2 / 3,
          title: Text(l10n.appTitle),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Calendar tab
            Padding(
              padding: EdgeInsets.all(UILayout.defaultPadding),
              child: CalendarPage(
                initialSelectedDate: _selectedDate,
                refreshTrigger: _refreshTrigger,
                uiType: CalendarUIType.mobile,
                onDateSelected: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
            ),
            // Transactions tab uses RightPanelWidget to show list/summary
            RightPanelWidget(
              selectedDate: _selectedDate,
              onTransactionAdded: () => setState(() => _refreshTrigger++),
              initialIndex: 0,
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            // reduce tab bar height to one third of the toolbar height for mobile
            height: kToolbarHeight * 2 / 3,
            child: Material(
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: IconTheme(
                data: IconThemeData(size: _tabIconSize),
                child: TabBar(
                  // Explicit colors so selected tab label is always visible
                  labelColor: UIColors.onPrimaryColor(context),
                  unselectedLabelColor: UIColors.onSurfaceColor(context),
                  indicatorColor: UIColors.onPrimaryColor(context),
                  indicatorWeight: 2.0,
                  // reduce label font size to fit the smaller tab bar
                  labelStyle: TextStyle(fontSize: _tabLabelSize),
                  unselectedLabelStyle: TextStyle(fontSize: _tabLabelSize),
                  tabs: [
                    Tab(
                      //icon: const Icon(Icons.calendar_today),
                      text: l10n.dashboard,
                    ),
                    Tab(
                      //icon: const Icon(Icons.list),
                      text: l10n.transactions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (context) =>
                  AddTransactionDialog(initialDate: _selectedDate),
            );
            if (result == true) setState(() => _refreshTrigger++);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // 계정 정보 다이얼로그
  void _showAccountInfoDialog(BuildContext context, User? user) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(UILayout.dialogPadding),
            constraints: BoxConstraints(
              maxWidth: UILayout.dialogMaxWidth,
              maxHeight: UILayout.dialogMaxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DialogHeaderWidget(
                  title: l10n.accountInfo,
                  onClose: () => Navigator.pop(context),
                ),
                const Divider(),
                SizedBox(height: UILayout.largeGap),
                Flexible(
                  child: SingleChildScrollView(child: AuthWidget(user: user)),
                ),
                SizedBox(height: UILayout.largeGap),
                DialogFooterWidget(onClose: () => Navigator.pop(context)),
              ],
            ),
          ),
        );
      },
    );
  }
}
