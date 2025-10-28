import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:window_manager/window_manager.dart';

import 'firebase_options.dart';
import 'view/auth/login.dart';
import 'view/auth/signup.dart';
import 'view/home.dart';
import 'view/uivalue.dart';

// 윈도우 화면 크기
const Size windowScreenSize = Size(1280, 720);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  // Windows 플랫폼 전용 설정
  if (!kIsWeb && Platform.isWindows) {
    await _initializeWindowManager();
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

// Window Manager 초기화
Future<void> _initializeWindowManager() async {
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: windowScreenSize,
    minimumSize: windowScreenSize,
    center: true,
    backgroundColor: Colors.transparent,
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
    return Builder(
      // Builder to provide a BuildContext for UIValue.appTheme(context)
      builder: (context) => MaterialApp(
        title: 'Financial Management App',
        theme: UIValue.appTheme(context),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
        },
      ),
    );
  }
}
