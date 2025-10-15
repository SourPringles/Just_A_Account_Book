import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:window_manager/window_manager.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'view/auth/login.dart';
import 'view/auth/signup.dart';
import 'view/home.dart';

// 기준 크기
const Size narrowScreenSize = Size(480, 800);
const Size mobileScreenSize = Size(480, 1000);
const Size windowScreenSize = Size(1280, 720);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  // Windows 플랫폼에서 창 크기 설정
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: windowScreenSize, // 창 크기 (너비 720px, 높이 1280px)
      minimumSize: windowScreenSize, // 최소 창 크기
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
