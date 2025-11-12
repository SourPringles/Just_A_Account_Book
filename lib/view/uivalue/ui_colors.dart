import 'package:flutter/material.dart';

/// UI 색상 정의
/// Light/Dark 모드별 색상을 정의합니다.
class UIColors {
  // ========== 색상 정의 (Light/Dark 모드 분리) ==========

  // 공통 색상 (모드 무관)
  static const Color commonPositiveColor = Colors.blue; // 긍정적 요소 색상
  static const Color commonNegativeColor = Colors.red; // 부정적 요소 색상
  static const Color commonNeutralColor = Colors.black; // 중립적 요소 색상
  static const Color commonExtraColor = Colors.grey; // 추가 중립적 요소 색상

  // 거래 관련 색상
  static const Color incomeColor = commonPositiveColor; // 수입 색상
  static const Color expenseColor = commonNegativeColor; // 지출 색상
  static const Color balancePositiveColor = commonPositiveColor; // 잔액 양수
  static const Color balanceNegativeColor = commonNegativeColor; // 잔액 음수

  // UI 요소 색상
  static const Color borderColor = Color(0xFFE0E0E0); // 테두리 색상 (Grey shade 300)
  static const Color dividerColor = Color(
    0xFFBDBDBD,
  ); // 구분선 색상 (Grey shade 400)
  static const Color shadowColor = Color(0x1A000000); // 그림자 색상 (투명도 0.1)
  static const Color todayBorderColor = Colors.orange; // 오늘 날짜 테두리
  static const Color warningColor = Colors.orange; // 경고 색상
  static const Color whiteColor = Colors.white; // 흰색

  // 배경 색상
  static const Color cardBackgroundLight = Color(
    0xFFF5F5F5,
  ); // 카드 배경 (Grey shade 100)

  // Light 모드 색상
  static const Color lightWeekdayTextColor = Colors.black; // 평일 날짜 색상
  static const Color lightDefaultTextColor = Color(
    0xFFAEB1B8,
  ); // 별도 정의하지 않은 텍스트 색상
  static const Color lightDefaultColor = Colors.black; // 별도 정의하지 않은 기본 색상
  static const Color lightBackgroundColor = Colors.white; // 바탕화면 색상

  // Dark 모드 색상
  static const Color darkWeekdayTextColor = Colors.white; // 평일 날짜 색상
  static const Color darkDefaultTextColor = Color(
    0xFFAEB1B8,
  ); // 별도 정의하지 않은 텍스트 색상
  static const Color darkDefaultColor = Colors.white; // 별도 정의하지 않은 기본 색상
  static const Color darkBackgroundColor = Color(0xFF1C1D1F); // 바탕화면 색상

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
        primary: commonPositiveColor,
        secondary: commonPositiveColor.withOpacity(0.8),
        surface: lightBackgroundColor,
        error: commonNegativeColor,
        outline: lightDefaultColor, // 테두리 색상
      ),
      scaffoldBackgroundColor: lightBackgroundColor,
      useMaterial3: true,
      // 모든 위젯에 디버그 테두리 추가
      extensions: [_DebugBorderTheme()],
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
        secondary: commonPositiveColor.withOpacity(0.8),
        surface: darkBackgroundColor,
        error: commonNegativeColor,
        outline: darkDefaultColor, // 테두리 색상
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      useMaterial3: true,
      // 모든 위젯에 디버그 테두리 추가
      extensions: [_DebugBorderTheme()],
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
