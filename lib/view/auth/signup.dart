import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import '../uivalue/ui_layout.dart';
import '../uivalue/ui_text.dart';
import '../uivalue/ui_colors.dart';
import 'widgets/auth_widget_email_input.dart';
import 'widgets/auth_widget_password_input.dart';
import 'widgets/auth_widget_name_input.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
                      style: UIText.extraLargeTextStyle(
                        context,
                        weight: FontWeight.bold,
                      ).copyWith(color: UIColors.incomeColor.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 오른쪽 패널 (회원가입 폼)
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(UILayout.defaultPadding),
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: _buildSignupForm(l10n),
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

  Widget _buildSignupForm(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 로고 또는 타이틀
          Icon(Icons.person_add, size: 80, color: UIColors.incomeColor),
          SizedBox(height: UILayout.smallGap),
          Text(
            l10n.createAccount,
            style: UIText.largeTextStyle(context, weight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: UILayout.largeGap),

          // 이름 입력
          AuthWidgetNameInput(controller: _nameController, autofocus: true),
          SizedBox(height: UILayout.mediumGap),

          // 이메일 입력
          AuthWidgetEmailInput(controller: _emailController),
          SizedBox(height: UILayout.mediumGap),

          // 비밀번호 입력 (엔터로 회원가입)
          Focus(
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                _handleSignUp();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: AuthWidgetPasswordInput(controller: _pwdController),
          ),
          SizedBox(height: UILayout.largeGap),

          // 회원가입 버튼
          _buildSignUpButton(l10n),
          SizedBox(height: UILayout.mediumGap),

          // 로그인 버튼
          _buildLoginButton(l10n),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(AppLocalizations l10n) {
    return ElevatedButton.icon(
      onPressed: _handleSignUp,
      icon: const Icon(Icons.person_add),
      label: Text(l10n.signup, style: UIText.mediumTextStyle(context)),
      style: ElevatedButton.styleFrom(
        backgroundColor: UIColors.incomeColor,
        foregroundColor: UIColors.whiteColor,
        padding: EdgeInsets.symmetric(
          vertical: UILayout.buttonPadding(context),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AppLocalizations l10n) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${l10n.alreadyHaveAccount} ",
            style: UIText.smallTextStyle(context),
          ),
          Text(
            l10n.login,
            style: UIText.smallTextStyle(context).copyWith(
              fontWeight: FontWeight.bold,
              color: UIColors.incomeColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context)!;

      try {
        await AuthService.signUpWithEmailPassword(
          email: _emailController.text.trim(),
          password: _pwdController.text,
          name: _nameController.text.trim(),
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/");
        }
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;

        String message = l10n.errorOccurredAuth;
        if (e.code == 'weak-password') {
          message = l10n.errorWeakPassword;
        } else if (e.code == 'email-already-in-use') {
          message = l10n.errorEmailInUse;
        } else if (e.code == 'invalid-email') {
          message = l10n.errorInvalidEmail;
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
            content: Text(
              '${AppLocalizations.of(context)!.errorOccurred}: ${e.toString()}',
            ),
            backgroundColor: UIColors.expenseColor,
          ),
        );
      }
    }
  }
}
