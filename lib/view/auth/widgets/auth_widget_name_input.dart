import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_text.dart';

/// 이름 입력 필드 위젯
class AuthWidgetNameInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;

  const AuthWidgetNameInput({
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
      validator: (val) {
        if (val == null || val.isEmpty) {
          return l10n.validationName;
        }
        return null;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: l10n.enterName,
        labelText: l10n.name,
        labelStyle: UIText.mediumTextStyle(context),
        prefixIcon: const Icon(Icons.person),
      ),
    );
  }
}
