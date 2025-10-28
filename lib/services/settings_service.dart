import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple settings service to persist user preferences like language and currency.
class SettingsService {
  static const _keyLanguage = 'preferred_language';
  static const _keyCurrency = 'preferred_currency';

  SettingsService._();
  static final SettingsService instance = SettingsService._();

  final ValueNotifier<String> language = ValueNotifier('system');
  final ValueNotifier<String> currency = ValueNotifier('KRW');

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    language.value = _prefs?.getString(_keyLanguage) ?? 'system';
    currency.value = _prefs?.getString(_keyCurrency) ?? 'KRW';
  }

  Future<void> setLanguage(String lang) async {
    language.value = lang;
    await _prefs?.setString(_keyLanguage, lang);
  }

  Future<void> setCurrency(String cur) async {
    currency.value = cur;
    await _prefs?.setString(_keyCurrency, cur);
  }
}
