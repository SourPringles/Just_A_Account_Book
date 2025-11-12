import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'dart:io' show Platform;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:window_manager/window_manager.dart';

import 'firebase_options.dart';
import 'view/auth/login.dart';
import 'view/auth/signup.dart';
import 'view/home/home_page.dart';
import 'view/settings/settings_page.dart';
import 'view/uivalue/ui_colors.dart';
import 'services/theme_service.dart';
import 'services/settings_service.dart';
import 'services/locale_service.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';

// 윈도우 화면 크기
const Size windowScreenSize = Size(1280, 720);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  // 모든 위젯에 테두리 표시 (디버그 모드)
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintPointersEnabled = false;
  debugPaintLayerBordersEnabled = false;
  debugRepaintRainbowEnabled = false;

  // Windows 플랫폼 전용 설정
  if (!kIsWeb && Platform.isWindows) {
    await _initializeWindowManager();
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase threading 경고 무시 (Windows 플랫폼 이슈)
  if (!kIsWeb && Platform.isWindows) {
    FlutterError.onError = (FlutterErrorDetails details) {
      // Firestore 스레드 경고는 무시
      if (details.exception.toString().contains('platform thread') ||
          details.exception.toString().contains('firebase_firestore')) {
        debugPrint(
          'Firestore threading warning (known Windows issue): ${details.exception}',
        );
        return;
      }
      // 다른 에러는 정상 처리
      FlutterError.presentError(details);
    };
  }

  // initialize services so saved preferences are loaded
  await ThemeService.instance.init();
  await SettingsService.instance.init();
  await LocaleService.instance.init();

  runApp(const MainApp());
}

// Window Manager 초기화
Future<void> _initializeWindowManager() async {
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: windowScreenSize,
    minimumSize: windowScreenSize,
    center: true,
    backgroundColor: UIColors.transparentColor,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeMode,
      builder: (context, mode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: LocaleService.instance.locale,
          builder: (context, currentLocale, _) {
            return Builder(
              // Builder to provide a BuildContext for UIColors.appTheme(context)
              builder: (ctx) => MaterialApp(
                title: 'Financial Management App',
                theme: UIColors.appTheme(ctx),
                darkTheme: UIColors.darkTheme(ctx),
                themeMode: mode,
                locale: currentLocale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('ko'), // 한국어
                  Locale('en'), // 영어
                ],
                initialRoute: '/',
                routes: {
                  '/': (context) => const HomePage(),
                  '/login': (context) => const LoginPage(),
                  '/signup': (context) => const SignupPage(),
                  '/settings': (context) => const SettingsPage(),
                },
              ),
            );
          },
        );
      },
    );
  }
}
