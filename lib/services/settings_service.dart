import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple settings service to persist user preferences like language and currency.
class SettingsService {
  static const _keyLanguage = 'preferred_language';
  static const _keyCurrency = 'preferred_currency';
  static const _keyCurrencySymbol = 'preferred_currency_symbol';

  SettingsService._();
  static final SettingsService instance = SettingsService._();

  final ValueNotifier<String> language = ValueNotifier('system');
  final ValueNotifier<String> currency = ValueNotifier('KRW');
  final ValueNotifier<String> currencySymbol = ValueNotifier('₩');

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    language.value = _prefs?.getString(_keyLanguage) ?? 'system';
    currency.value = _prefs?.getString(_keyCurrency) ?? 'KRW';
    currencySymbol.value = _prefs?.getString(_keyCurrencySymbol) ?? '₩';
  }

  Future<void> setLanguage(String lang) async {
    language.value = lang;
    await _prefs?.setString(_keyLanguage, lang);
  }

  Future<void> setCurrency(String cur) async {
    currency.value = cur;
    await _prefs?.setString(_keyCurrency, cur);
    // 통화 코드에 따라 기호도 자동으로 설정
    currencySymbol.value = cur == 'USD' ? '\$' : '₩';
    await _prefs?.setString(_keyCurrencySymbol, currencySymbol.value);
  }
}
