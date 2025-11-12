import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../uivalue/ui_layout.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext con, AsyncSnapshot<User?> user) {
        if (!user.hasData) {
          return const LoginPage();
        } else {
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
