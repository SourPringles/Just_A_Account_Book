import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_text.dart';

/// 이메일 입력 필드 위젯
class AuthWidgetEmailInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;

  const AuthWidgetEmailInput({
    super.key,
    required this.controller,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: TextInputType.emailAddress,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return l10n.validationEmpty;
        }
        if (!val.contains('@')) {
          return l10n.validationEmail;
        }
        return null;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: l10n.enterEmail,
        labelText: l10n.email,
        labelStyle: UIText.mediumTextStyle(context),
        prefixIcon: const Icon(Icons.email),
      ),
    );
  }
}
