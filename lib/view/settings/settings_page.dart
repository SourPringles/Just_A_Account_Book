import 'package:flutter/material.dart';
import '../../services/theme_service.dart';
// import '../../services/settings_service.dart';
import '../uivalue.dart';
import 'widgets/theme_section_widget.dart';
// import 'widgets/language_section_widget.dart';
// import 'widgets/currency_section_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // String _lang = SettingsService.instance.language.value;
  // String _currency = SettingsService.instance.currency.value;
  ThemeMode _theme = ThemeService.instance.themeMode.value;

  late VoidCallback _themeListener;

  @override
  void initState() {
    super.initState();
    // listen for external changes (keeps UI in sync)
    // SettingsService.instance.language.addListener(() {
    //   setState(() {
    //     _lang = SettingsService.instance.language.value;
    //   });
    // });
    // SettingsService.instance.currency.addListener(() {
    //   setState(() {
    //     _currency = SettingsService.instance.currency.value;
    //   });
    // });
    _themeListener = () {
      // Guard setState with mounted to avoid calling it after dispose.
      if (!mounted) return;
      setState(() {
        _theme = ThemeService.instance.themeMode.value;
      });
    };
    ThemeService.instance.themeMode.addListener(_themeListener);
  }

  @override
  void dispose() {
    // Remove listener to avoid setState being called after this widget is disposed.
    ThemeService.instance.themeMode.removeListener(_themeListener);
    super.dispose();
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
              ThemeSectionWidget(
                currentTheme: _theme,
                onThemeChanged: (theme) async {
                  await ThemeService.instance.setThemeMode(theme);
                },
              ),

              const Divider(),

              // 언어 설정 (주석 처리됨 - 필요시 활성화)
              // LanguageSectionWidget(
              //   currentLanguage: _lang,
              //   onLanguageChanged: (lang) async {
              //     await SettingsService.instance.setLanguage(lang);
              //   },
              // ),
              //
              // const Divider(),

              // 통화 설정 (주석 처리됨 - 필요시 활성화)
              // CurrencySectionWidget(
              //   currentCurrency: _currency,
              //   onCurrencyChanged: (currency) async {
              //     await SettingsService.instance.setCurrency(currency);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
