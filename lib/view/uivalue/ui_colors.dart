import 'package:flutter/material.dart';

/// UI 색상 정의
/// Light/Dark 모드별 색상을 정의합니다.
class UIColors {
  // ========== 색상 정의 (Light/Dark 모드 분리) ==========

  // 공통 색상 (모드 무관)
  // 새로운 팔레트: 참조 사이트의 감성(부드럽고 현대적인 톤)을 반영한 색상
  // primary 계열: 그린, 긍정(수입) 강조는 그린, 부정(지출)은 레드
  static const Color commonPrimaryColor = Color(
    0xFF10B981,
  ); //Color(0xFF2563EB); // Indigo-600
  static const Color commonPositiveColor = Color(0xFF10B981); // Emerald (수입/긍정)
  static const Color commonNegativeColor = Color(0xFFEF4444); // Red (지출/부정)
  static const Color commonNeutralColor = Color(0xFF374151); // Slate-700 (본문)
  static const Color commonExtraColor = Color(0xFF9CA3AF); // Gray-400 (보조)
  static const Color saturdayColor = Color(0xFF2563EB); // Indigo-600
  static const Color sundayColor = Color(0xFFEF4444); // Red (주말)

  // 거래 관련 색상
  static const Color incomeColor = commonPositiveColor; // 수입 색상 (green)
  static const Color expenseColor = commonNegativeColor; // 지출 색상 (red)
  static const Color balancePositiveColor = commonPositiveColor; // 잔액 양수
  static const Color balanceNegativeColor = commonNegativeColor; // 잔액 음수

  // UI 요소 색상
  static const Color borderColor = Color(0xFFE5E7EB); // Cool gray 200
  static const Color dividerColor = Color(0xFFCBD5E1); // Slate-300
  static const Color shadowColor = Color(0x1F000000); // 그림자 색상 (투명도 약 12%)
  static const Color todayBorderColor = Color(0xFFF59E0B); // Amber (오늘/강조)
  static const Color warningColor = Color(0xFFF59E0B); // 경고 색상
  static const Color whiteColor = Colors.white; // 흰색
  static const Color transparentColor = Color(0x00000000); // 투명

  // 배경 색상
  static const Color cardBackgroundLight = Color(
    0xFFF8FAFC,
  ); // Off-white (very light)

  // Light 모드 색상
  static const Color lightWeekdayTextColor = commonNeutralColor; // 평일 날짜 색상
  static const Color lightDefaultTextColor = Color(
    0xFF4B5563,
  ); // Gray-600 (보조텍스트)
  static const Color lightDefaultColor = commonNeutralColor; // 기본 텍스트
  static const Color lightBackgroundColor = Color(0xFFF7FAFC); // 앱 배경 (밝은 회색 톤)

  // Dark 모드 색상
  static const Color darkWeekdayTextColor = Color(0xFFE6EEF8); // 밝은 텍스트
  static const Color darkDefaultTextColor = Color(0xFFD1D5DB); // Slate-300
  static const Color darkDefaultColor = Color(0xFFFFFFFF); // 기본 텍스트(다크)
  static const Color darkBackgroundColor = Color(
    0xFF0F1724,
  ); // 다크 배경 (진한 네이비/슬레이트)

  // ========== Theme-aware 색상 헬퍼 메서드 ==========

  // 기본 텍스트 색상
  static Color textPrimaryColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? darkDefaultTextColor
        : lightDefaultTextColor;
  }

  // 약한 텍스트 색상 (부가 정보 등)
  static Color mutedTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? Colors.grey.shade300
        : Colors.grey.shade600;
  }

  // 기본 컬러 (모드에 따라 라이트/다크 기본 색상 반환)
  static Color defaultColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkDefaultColor : lightDefaultColor;
  }

  // 평일 날짜 색상
  static Color weekdayDateTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? darkWeekdayTextColor
        : lightWeekdayTextColor;
  }

  // 바탕화면 색상
  static Color backgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? darkBackgroundColor
        : lightBackgroundColor;
  }

  // 카드/칩 배경 색상 (테마에 따라 다르게 사용)
  static Color cardBackground(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? const Color(0xFF242526)
        : cardBackgroundLight;
  }

  // 주말 색상
  // 주말 색상 (토큰 사용)
  static Color saturdayTextColor(BuildContext context) => saturdayColor;
  static Color sundayTextColor(BuildContext context) => sundayColor;

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
        primary: commonPositiveColor,
        secondary: commonPositiveColor.withAlpha(204),
        surface: lightBackgroundColor,
        error: commonNegativeColor,
        outline: lightDefaultColor, // 테두리 색상
      ),
      scaffoldBackgroundColor: lightBackgroundColor,
      useMaterial3: true,
      // 모든 위젯에 디버그 테두리 추가
      extensions: [_DebugBorderTheme()],
      // AppBar / Button 테마로 전역 색상 통일
      appBarTheme: const AppBarTheme(
        backgroundColor: UIColors.commonPrimaryColor,
        foregroundColor: UIColors.whiteColor,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: commonPrimaryColor,
          foregroundColor: whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: commonPrimaryColor),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: commonPrimaryColor,
          side: BorderSide(color: borderColor),
        ),
      ),
      // Container 기본 장식
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: lightDefaultColor, width: 1), // Light 모드: 검은색
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: lightDefaultColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightDefaultColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightDefaultColor, width: 2),
        ),
      ),
    );
  }

  /// Dark 모드 테마
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: commonPositiveColor,
        secondary: commonPositiveColor.withAlpha(204),
        surface: darkBackgroundColor,
        error: commonNegativeColor,
        outline: darkDefaultColor, // 테두리 색상
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      useMaterial3: true,
      // 모든 위젯에 디버그 테두리 추가
      extensions: [_DebugBorderTheme()],
      // AppBar / Button 테마 (다크 모드)
      appBarTheme: const AppBarTheme(
        backgroundColor: UIColors.commonPrimaryColor,
        foregroundColor: UIColors.whiteColor,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: commonPrimaryColor,
          foregroundColor: whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: commonPrimaryColor),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: commonPrimaryColor,
          side: BorderSide(color: borderColor),
        ),
      ),
      // Container 기본 장식
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: darkDefaultColor, width: 1), // Dark 모드: 흰색
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: darkDefaultColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: darkDefaultColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: darkDefaultColor, width: 2),
        ),
      ),
    );
  }
}

class _DebugBorderTheme extends ThemeExtension<_DebugBorderTheme> {
  @override
  ThemeExtension<_DebugBorderTheme> copyWith() => this;

  @override
  ThemeExtension<_DebugBorderTheme> lerp(
    ThemeExtension<_DebugBorderTheme>? other,
    double t,
  ) => this;
}
