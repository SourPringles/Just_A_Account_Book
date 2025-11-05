import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 언어 설정을 관리하는 서비스
class LocaleService {
  static final LocaleService instance = LocaleService._internal();
  LocaleService._internal();

  static const String _localeKey = 'app_locale';
  
  final ValueNotifier<Locale> locale = ValueNotifier(const Locale('ko'));

  /// 초기화
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedLocale = prefs.getString(_localeKey);
    
    if (savedLocale != null) {
      locale.value = Locale(savedLocale);
    }
  }

  /// 언어 변경
  Future<void> setLocale(Locale newLocale) async {
    if (locale.value == newLocale) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
    locale.value = newLocale;
  }

  /// 한국어로 변경
  Future<void> setKorean() => setLocale(const Locale('ko'));

  /// 영어로 변경
  Future<void> setEnglish() => setLocale(const Locale('en'));
}
