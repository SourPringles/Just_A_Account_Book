import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple service that persists the user's theme choice and exposes a
/// ValueNotifier<ThemeMode> so the app can reactively rebuild when the
/// selection changes.
class ThemeService {
  static const _prefKey = 'preferred_theme_mode';

  ThemeService._();
  static final ThemeService instance = ThemeService._();

  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final str = _prefs!.getString(_prefKey) ?? 'system';
    themeMode.value = _stringToMode(str);
  }

  ThemeMode _stringToMode(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _modeToString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _prefs?.setString(_prefKey, _modeToString(mode));
  }
}
