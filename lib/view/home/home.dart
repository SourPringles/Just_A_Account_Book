import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../uivalue/ui_layout.dart';

import '../../services/auth_service.dart';
import '../auth/login.dart';
import '../auth/auth.dart';
import 'widgets/left_panel_widget.dart';
import 'widgets/right_panel_widget.dart';
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
        // 우측 - 거래내역/요약
        Expanded(
          child: RightPanelWidget(
            selectedDate: _selectedDate,
            initialIndex: _rightPanelIndex,
            onIndexChanged: (i) => setState(() => _rightPanelIndex = i),
            onTransactionAdded: () => setState(() => _refreshTrigger++),
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
                  title: '계정 정보',
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
