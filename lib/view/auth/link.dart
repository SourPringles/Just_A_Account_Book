import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../uivalue/ui_layout.dart';
import '../uivalue/ui_text.dart';
import '../uivalue/ui_colors.dart';
import 'widgets/auth_widget_email_input.dart';
import 'widgets/auth_widget_password_input.dart';

class LinkPage extends StatefulWidget {
  const LinkPage({super.key});

  @override
  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Row(
        children: [
          // 왼쪽 패널
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    UIColors.incomeColor.withOpacity(0.1),
                    UIColors.expenseColor.withOpacity(0.1),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 120,
                      color: UIColors.incomeColor.withOpacity(0.3),
                    ),
                    SizedBox(height: UILayout.largeGap),
                    Text(
                      l10n.appTitle,
                      style: UIText.extraLargeTextStyle(context, weight: FontWeight.bold)
                          .copyWith(color: UIColors.incomeColor.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 오른쪽 패널 (계정 연결 폼)
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(UILayout.defaultPadding),
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: _buildLinkForm(l10n),
                      ),
                    ),
                  ),
                ),
                // 우상단 설정 버튼
                Positioned(
                  top: UILayout.defaultPadding,
                  right: UILayout.defaultPadding,
                  child: IconButton(
                    icon: const Icon(Icons.tune),
                    tooltip: l10n.settings,
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkForm(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 로고 또는 타이틀
          Icon(
            Icons.link,
            size: 80,
            color: UIColors.incomeColor,
          ),
          SizedBox(height: UILayout.smallGap),
          Text(
            l10n.linkAccount,
            style: UIText.largeTextStyle(context, weight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: UILayout.smallGap),
          Text(
            l10n.linkAccountDescription,
            style: UIText.smallTextStyle(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: UILayout.largeGap),
          
          // 이메일 입력
          AuthWidgetEmailInput(
            controller: _emailController,
            autofocus: true,
          ),
          SizedBox(height: UILayout.mediumGap),
          
          // 비밀번호 입력 (엔터로 연결)
          Focus(
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent && 
                  event.logicalKey == LogicalKeyboardKey.enter) {
                _handleLinkAccount();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: AuthWidgetPasswordInput(
              controller: _pwdController,
            ),
          ),
          SizedBox(height: UILayout.largeGap),
          
          // 링크 버튼
          _buildLinkButton(l10n),
        ],
      ),
    );
  }

  Widget _buildLinkButton(AppLocalizations l10n) {
    return ElevatedButton.icon(
      onPressed: _handleLinkAccount,
      icon: const Icon(Icons.link),
      label: Text(
        l10n.linkAccount,
        style: UIText.mediumTextStyle(context),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: UIColors.incomeColor,
        foregroundColor: UIColors.whiteColor,
        padding: EdgeInsets.symmetric(vertical: UILayout.buttonPadding(context)),
      ),
    );
  }

  Future<void> _handleLinkAccount() async {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context)!;
      
      try {
        final credential = EmailAuthProvider.credential(
          email: _emailController.text.trim(),
          password: _pwdController.text,
        );
        
        await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.accountLinkedSuccess),
            backgroundColor: UIColors.incomeColor,
          ),
        );
        
        Navigator.pushReplacementNamed(context, "/");
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        
        String message = l10n.errorOccurredAuth;
        if (e.code == 'weak-password') {
          message = l10n.errorWeakPassword;
        } else if (e.code == 'email-already-in-use') {
          message = l10n.errorEmailInUse;
        } else if (e.code == 'provider-already-linked') {
          message = l10n.errorProviderLinked;
        } else if (e.code == 'invalid-credential') {
          message = l10n.errorInvalidCredential;
        } else if (e.code == 'credential-already-in-use') {
          message = l10n.errorCredentialInUse;
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: UIColors.expenseColor,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.errorOccurred}: ${e.toString()}'),
            backgroundColor: UIColors.expenseColor,
          ),
        );
      }
    }
  }
}
