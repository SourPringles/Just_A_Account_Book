import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../services/theme_service.dart';
import '../../services/locale_service.dart';
import '../../services/settings_service.dart';
import '../uivalue/ui_layout.dart';
import 'widgets/settings_widget_theme_section.dart';
import 'widgets/settings_widget_language_section.dart';
import 'widgets/settings_widget_currency_section.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _theme = ThemeService.instance.themeMode.value;
  Locale _locale = LocaleService.instance.locale.value;
  String _currency = SettingsService.instance.currency.value;

  late VoidCallback _themeListener;
  late VoidCallback _localeListener;
  late VoidCallback _currencyListener;

  @override
  void initState() {
    super.initState();
    // listen for external changes (keeps UI in sync)
    _themeListener = () {
      // Guard setState with mounted to avoid calling it after dispose.
      if (!mounted) return;
      setState(() {
        _theme = ThemeService.instance.themeMode.value;
      });
    };
    ThemeService.instance.themeMode.addListener(_themeListener);

    _localeListener = () {
      if (!mounted) return;
      setState(() {
        _locale = LocaleService.instance.locale.value;
      });
    };
    LocaleService.instance.locale.addListener(_localeListener);

    _currencyListener = () {
      if (!mounted) return;
      setState(() {
        _currency = SettingsService.instance.currency.value;
      });
    };
    SettingsService.instance.currency.addListener(_currencyListener);
  }

  @override
  void dispose() {
    // Remove listener to avoid setState being called after this widget is disposed.
    ThemeService.instance.themeMode.removeListener(_themeListener);
    LocaleService.instance.locale.removeListener(_localeListener);
    SettingsService.instance.currency.removeListener(_currencyListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Padding(
        padding: EdgeInsets.all(UILayout.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 테마 설정 위젯
              ThemeSectionWidget(
                currentTheme: _theme,
                onThemeChanged: (theme) async {
                  await ThemeService.instance.setThemeMode(theme);
                },
              ),

              const Divider(),

              // 언어 설정 위젯
              LanguageSectionWidget(
                currentLocale: _locale,
                onLocaleChanged: (locale) async {
                  await LocaleService.instance.setLocale(locale);
                },
              ),

              const Divider(),

              // 통화 설정
              CurrencySectionWidget(
                currentCurrency: _currency,
                onCurrencyChanged: (currency) async {
                  await SettingsService.instance.setCurrency(currency);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
