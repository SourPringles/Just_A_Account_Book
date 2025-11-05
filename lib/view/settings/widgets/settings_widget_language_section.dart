import 'package:flutter/material.dart';
import '../../uivalue/ui_text.dart';

class LanguageSectionWidget extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSectionWidget({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('언어', style: UIText.largeTextStyle(context)),
        RadioListTile<String>(
          title: const Text('시스템 기본'),
          value: 'system',
          groupValue: currentLanguage,
          onChanged: (v) {
            if (v != null) onLanguageChanged(v);
          },
        ),
        RadioListTile<String>(
          title: const Text('한국어'),
          value: 'ko',
          groupValue: currentLanguage,
          onChanged: (v) {
            if (v != null) onLanguageChanged(v);
          },
        ),
        RadioListTile<String>(
          title: const Text('English'),
          value: 'en',
          groupValue: currentLanguage,
          onChanged: (v) {
            if (v != null) onLanguageChanged(v);
          },
        ),
      ],
    );
  }
}
