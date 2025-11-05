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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          // 왼쪽 패널 (나중에 내용 추가 가능)
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
          
          // 오른쪽 패널 (로그인 폼)
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(UILayout.defaultPadding),
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: _buildLoginForm(l10n),
                      ),
                    ),
                  ),
                ),
                // 우상단 설정 버튼
                Positioned(
                  top: UILayout.defaultPadding,
                  right: UILayout.defaultPadding,
                  child: IgnorePointer(
                    ignoring: false,
                    child: ExcludeFocus(
                      child: IconButton(
                        icon: const Icon(Icons.tune),
                        tooltip: l10n.settings,
                        onPressed: () => Navigator.pushNamed(context, '/settings'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 로고 또는 타이틀
          Icon(
            Icons.login,
            size: 80,
            color: UIColors.incomeColor,
          ),
          SizedBox(height: UILayout.smallGap),
          Text(
            l10n.welcomeBack,
            style: UIText.largeTextStyle(context, weight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: UILayout.largeGap),
          
          // 이메일 입력
          AuthWidgetEmailInput(
            controller: _emailController,
            autofocus: true,
          ),
          SizedBox(height: UILayout.mediumGap),
          
          // 비밀번호 입력
          AuthWidgetPasswordInput(
            controller: _pwdController,
            onSubmitted: _handleLogin,
          ),
          SizedBox(height: UILayout.largeGap),
          
          // 로그인 버튼
          _buildLoginButton(l10n),
          SizedBox(height: UILayout.mediumGap),
          
          // 구분선
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: UILayout.mediumGap),
                child: Text('OR', style: UIText.smallTextStyle(context)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: UILayout.mediumGap),
          
          // 임시 로그인 버튼
          _buildAnonymousLoginButton(l10n),
          SizedBox(height: UILayout.mediumGap),
          
          // 회원가입 버튼
          _buildSignUpButton(l10n),
        ],
      ),
    );
  }

  Widget _buildLoginButton(AppLocalizations l10n) {
    return ElevatedButton.icon(
      onPressed: _handleLogin,
      icon: const Icon(Icons.login),
      label: Text(
        l10n.login,
        style: UIText.mediumTextStyle(context),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: UIColors.incomeColor,
        foregroundColor: UIColors.whiteColor,
        padding: EdgeInsets.symmetric(vertical: UILayout.buttonPadding(context)),
      ),
    );
  }

  Widget _buildAnonymousLoginButton(AppLocalizations l10n) {
    return OutlinedButton.icon(
      onPressed: _handleAnonymousLogin,
      icon: const Icon(Icons.person_off),
      label: Text(
        l10n.continueAsGuest,
        style: UIText.mediumTextStyle(context),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: UILayout.buttonPadding(context)),
      ),
    );
  }

  Widget _buildSignUpButton(AppLocalizations l10n) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, '/signup'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${l10n.dontHaveAccount} ",
            style: UIText.smallTextStyle(context),
          ),
          Text(
            l10n.signup,
            style: UIText.smallTextStyle(context).copyWith(
              fontWeight: FontWeight.bold,
              color: UIColors.incomeColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context)!;
      
      try {
        await AuthService.signInWithEmailPassword(
          email: _emailController.text.trim(),
          password: _pwdController.text,
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/");
        }
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        
        String message = l10n.errorOccurredAuth;
        if (e.code == 'user-not-found') {
          message = l10n.errorUserNotFound;
        } else if (e.code == 'wrong-password') {
          message = l10n.errorWrongPassword;
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
            content: Text('${AppLocalizations.of(context)!.errorOccurred}: ${e.toString()}'),
            backgroundColor: UIColors.expenseColor,
          ),
        );
      }
    }
  }

  Future<void> _handleAnonymousLogin() async {
    try {
      await AuthService.signInAnonymously();
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/");
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.code}'),
          backgroundColor: UIColors.expenseColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: UIColors.expenseColor,
        ),
      );
    }
  }
}
