import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_text.dart';

/// 비밀번호 입력 필드 위젯
class AuthWidgetPasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final bool autofocus;
  final String? labelText;
  final String? hintText;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;

  const AuthWidgetPasswordInput({
    super.key,
    required this.controller,
    this.autofocus = false,
    this.labelText,
    this.hintText,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  State<AuthWidgetPasswordInput> createState() =>
      _AuthWidgetPasswordInputState();
}

class _AuthWidgetPasswordInputState extends State<AuthWidgetPasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: widget.onSubmitted != null
          ? (_) => widget.onSubmitted!()
          : null,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return l10n.validationEmpty;
        }
        if (val.length < 6) {
          return l10n.validationPassword;
        }
        return null;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: widget.hintText ?? l10n.enterPassword,
        labelText: widget.labelText ?? l10n.password,
        labelStyle: UIText.mediumTextStyle(context),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
