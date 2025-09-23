import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:window_manager/window_manager.dart';

import 'view/auth/login.dart';
import 'view/auth/signup.dart';
import 'view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Windows 플랫폼에서 창 크기 설정
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 800), // 창 크기 (너비 1200px, 높이 800px)
      minimumSize: Size(800, 600), // 최소 창 크기
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
      title: 'Flutter Demo',
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
