import 'package:flutter/material.dart';

/// UI 색상 정의
/// Light/Dark 모드별 색상을 정의합니다.
class UIColors {
  // ========== 색상 정의 (Light/Dark 모드 분리) ==========
  
  // 공통 색상 (모드 무관)
  static const Color commonButtonColor = Colors.blue; // 기본 버튼 색상
  static const Color commonDeleteCancelColor = Colors.red; // 삭제/취소 버튼 색상
  
  // Light 모드 색상
  static const Color lightWeekdayTextColor = Colors.black; // 평일 날짜 색상
  static const Color lightDefaultTextColor = Colors.black; // 별도 정의하지 않은 텍스트 색상
  static const Color lightBackgroundColor = Colors.white; // 바탕화면 색상
  
  // Dark 모드 색상
  static const Color darkWeekdayTextColor = Colors.white; // 평일 날짜 색상
  static const Color darkDefaultTextColor = Colors.white; // 별도 정의하지 않은 텍스트 색상
  static const Color darkBackgroundColor = Colors.black; // 바탕화면 색상

  // ========== Theme-aware 색상 헬퍼 메서드 ==========
  
  // 기본 텍스트 색상
  static Color textPrimaryColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkDefaultTextColor : lightDefaultTextColor;
  }

  // 약한 텍스트 색상 (부가 정보 등)
  static Color mutedTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? Colors.grey.shade300
        : Colors.grey.shade600;
  }

  // 평일 날짜 색상
  static Color weekdayDateTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkWeekdayTextColor : lightWeekdayTextColor;
  }

  // 바탕화면 색상
  static Color backgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkBackgroundColor : lightBackgroundColor;
  }

  // 주말 색상
  static Color saturdayTextColor(BuildContext context) => Colors.blue;
  static Color sundayTextColor(BuildContext context) => Colors.red;

  // 요일에 따른 텍스트 색상 (DateTime.weekday: Mon=1 .. Sun=7)
  static Color weekdayTextColor(BuildContext context, int weekday) {
    if (weekday == DateTime.saturday) return saturdayTextColor(context);
    if (weekday == DateTime.sunday) return sundayTextColor(context);
    return weekdayDateTextColor(context); // 평일은 새로 정의한 색상 사용
  }

  // Theme 색상 관련
  static Color onPrimaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;
  static Color onSurfaceColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  // ========== Theme 생성 메서드 ==========
  
  /// Light 모드 테마
  static ThemeData appTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: commonButtonColor,
        secondary: commonButtonColor.withOpacity(0.8),
        surface: lightBackgroundColor,
        error: commonDeleteCancelColor,
      ),
      scaffoldBackgroundColor: lightBackgroundColor,
      useMaterial3: true,
    );
  }

  /// Dark 모드 테마
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: commonButtonColor,
        secondary: commonButtonColor.withOpacity(0.8),
        surface: darkBackgroundColor,
        error: commonDeleteCancelColor,
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      useMaterial3: true,
    );
  }
}
