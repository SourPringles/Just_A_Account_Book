import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_text.dart';

class ThemeSectionWidget extends StatelessWidget {
  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ThemeSectionWidget({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.theme, style: UIText.largeTextStyle(context)),
        RadioListTile<ThemeMode>(
          title: Text(l10n.themeSystem),
          value: ThemeMode.system,
          groupValue: currentTheme,
          onChanged: (v) {
            if (v != null) onThemeChanged(v);
          },
        ),
        RadioListTile<ThemeMode>(
          title: Text(l10n.themeLight),
          value: ThemeMode.light,
          groupValue: currentTheme,
          onChanged: (v) {
            if (v != null) onThemeChanged(v);
          },
        ),
        RadioListTile<ThemeMode>(
          title: Text(l10n.themeDark),
          value: ThemeMode.dark,
          groupValue: currentTheme,
          onChanged: (v) {
            if (v != null) onThemeChanged(v);
          },
        ),
      ],
    );
  }
}
