import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_text.dart';

class LanguageSectionWidget extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const LanguageSectionWidget({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.language,
          style: UIText.largeTextStyle(context),
        ),
        SizedBox(height: UILayout.smallGap),
        
        RadioListTile<Locale>(
          title: Text(l10n.korean),
          value: const Locale('ko'),
          groupValue: currentLocale,
          onChanged: (Locale? value) {
            if (value != null) {
              onLocaleChanged(value);
            }
          },
        ),
        
        RadioListTile<Locale>(
          title: Text(l10n.english),
          value: const Locale('en'),
          groupValue: currentLocale,
          onChanged: (Locale? value) {
            if (value != null) {
              onLocaleChanged(value);
            }
          },
        ),
      ],
    );
  }
}
