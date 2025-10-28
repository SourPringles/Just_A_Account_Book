import 'package:flutter/material.dart';
import '../../uivalue.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('테마', style: UIValue.titleStyle(context)),
        RadioListTile<ThemeMode>(
          title: const Text('시스템 기본'),
          value: ThemeMode.system,
          groupValue: currentTheme,
          onChanged: (v) {
            if (v != null) onThemeChanged(v);
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('라이트'),
          value: ThemeMode.light,
          groupValue: currentTheme,
          onChanged: (v) {
            if (v != null) onThemeChanged(v);
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('다크'),
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
