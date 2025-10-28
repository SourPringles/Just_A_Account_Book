import 'package:flutter/material.dart';
import '../../services/theme_service.dart';
import '../../services/settings_service.dart';
import '../uivalue.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _lang = SettingsService.instance.language.value;
  String _currency = SettingsService.instance.currency.value;
  ThemeMode _theme = ThemeService.instance.themeMode.value;

  @override
  void initState() {
    super.initState();
    // listen for external changes (keeps UI in sync)
    SettingsService.instance.language.addListener(() {
      setState(() {
        _lang = SettingsService.instance.language.value;
      });
    });
    SettingsService.instance.currency.addListener(() {
      setState(() {
        _currency = SettingsService.instance.currency.value;
      });
    });
    ThemeService.instance.themeMode.addListener(() {
      setState(() {
        _theme = ThemeService.instance.themeMode.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: Padding(
        padding: EdgeInsets.all(UIValue.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('테마', style: UIValue.titleStyle(context)),
              RadioListTile<ThemeMode>(
                title: const Text('시스템 기본'),
                value: ThemeMode.system,
                groupValue: _theme,
                onChanged: (v) async {
                  if (v != null) await ThemeService.instance.setThemeMode(v);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('라이트'),
                value: ThemeMode.light,
                groupValue: _theme,
                onChanged: (v) async {
                  if (v != null) await ThemeService.instance.setThemeMode(v);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('다크'),
                value: ThemeMode.dark,
                groupValue: _theme,
                onChanged: (v) async {
                  if (v != null) await ThemeService.instance.setThemeMode(v);
                },
              ),

              const Divider(),

              //Text('언어', style: UIValue.titleStyle(context)),
              //RadioListTile<String>(
              //  title: const Text('시스템 기본'),
              //  value: 'system',
              //  groupValue: _lang,
              //  onChanged: (v) async {
              //    if (v != null) await SettingsService.instance.setLanguage(v);
              //  },
              //),
              //RadioListTile<String>(
              //  title: const Text('한국어'),
              //  value: 'ko',
              //  groupValue: _lang,
              //  onChanged: (v) async {
              //    if (v != null) await SettingsService.instance.setLanguage(v);
              //  },
              //),
              //RadioListTile<String>(
              //  title: const Text('English'),
              //  value: 'en',
              //  groupValue: _lang,
              //  onChanged: (v) async {
              //    if (v != null) await SettingsService.instance.setLanguage(v);
              //  },
              //),
              //
              //const Divider(),

              //Text('통화 단위', style: UIValue.titleStyle(context)),
              //RadioListTile<String>(
              //  title: const Text('KRW (₩)'),
              //  value: 'KRW',
              //  groupValue: _currency,
              //  onChanged: (v) async {
              //    if (v != null) await SettingsService.instance.setCurrency(v);
              //  },
              //),
              //RadioListTile<String>(
              //  title: const Text('USD ($)'),
              //  value: 'USD',
              //  groupValue: _currency,
              //  onChanged: (v) async {
              //    if (v != null) await SettingsService.instance.setCurrency(v);
              //  },
              //),
            ],
          ),
        ),
      ),
    );
  }
}
