import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:window_manager/window_manager.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'view/auth/login.dart';
import 'view/auth/signup.dart';
import 'view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  // Windows 플랫폼에서 창 크기 설정
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(480, 1000), // 창 크기 (너비 480px, 높이 1000px)
      minimumSize: Size(360, 800), // 최소 창 크기
      center: true, // 화면 중앙에 배치
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}
