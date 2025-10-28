import 'package:flutter/material.dart';

/// 중앙화된 UI 값들
/// 화면 크기/간격/아이콘/테두리 등 플랫폼(화면 너비)에 따라 달라질 수 있는 값을
/// 이 파일에서 한 곳에 정의합니다.
class UIValue {
  // 화면 크기
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // 브레이크포인트
  static bool isNarrow(BuildContext context) => screenWidth(context) < 400;
  static bool isSmall(BuildContext context) => screenWidth(context) < 600;

  // 공통 패딩(gap)
  static const double tinyGap = 4.0;
  static const double smallGap = 8.0;
  static const double mediumGap = 15.0; // 기존 코드에서 자주 사용되는 15
  static const double largeGap = 16.0; // 기존 코드에서 16으로 쓰인 값
  static const double xlargeGap = 20.0;

  // 기본 내부 여백
  static const double defaultPadding = 16.0;

  // 다이얼로그 크기 제한
  static const double dialogMaxWidth = 400.0;
  static const double dialogMaxHeight = 500.0;

  // 거래내역 라벨 너비
  static const double transactionLabelWidth = 60.0;

  // 테두리 두께
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;

  // 아이콘/폰트 사이즈(간단히 중앙화)
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXL = 64.0;

  // 버튼/폼 관련
  static double buttonPadding(BuildContext context) =>
      isNarrow(context) ? 8.0 : 12.0;
  static double buttonSpacing(BuildContext context) =>
      isNarrow(context) ? 8.0 : 12.0;

  // 다이얼로그 내부 패딩
  static const double dialogPadding = 24.0;

  // auth 관련 동적값들을 단순 래핑
  static double titleFontSize(BuildContext context) {
    final w = screenWidth(context);
    if (w < 350) return 16.0;
    if (w < 400) return 18.0;
    if (w < 600) return 20.0;
    return 22.0;
  }

  static double labelFontSize(BuildContext context) {
    final w = screenWidth(context);
    if (w < 350) return 14.0;
    if (w < 400) return 15.0;
    return 16.0;
  }

  static double contentFontSize(BuildContext context) {
    final w = screenWidth(context);
    if (w < 350) return 10.0;
    if (w < 400) return 11.0;
    return 12.0;
  }

  // 버튼/서브타이틀 등 중간 크기 텍스트
  static double subtitleFontSize(BuildContext context) {
    final w = screenWidth(context);
    if (w < 400) return 14.0;
    return 16.0;
  }

  // 버튼 텍스트
  static double buttonTextSize(BuildContext context) {
    final w = screenWidth(context);
    if (w < 400) return 14.0;
    return 18.0;
  }

  // TextStyle helpers for reuse across the app
  static TextStyle titleStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: titleFontSize(context),
      fontWeight: weight ?? FontWeight.bold,
      color: color,
    );
  }

  static TextStyle subtitleStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: subtitleFontSize(context),
      fontWeight: weight ?? FontWeight.w600,
      color: color,
    );
  }

  static TextStyle labelStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: labelFontSize(context),
      fontWeight: weight ?? FontWeight.w600,
      color: color,
    );
  }

  static TextStyle contentStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: contentFontSize(context),
      fontWeight: weight ?? FontWeight.normal,
      color: color,
    );
  }

  static TextStyle buttonStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: buttonTextSize(context),
      fontWeight: weight ?? FontWeight.w600,
      color: color,
    );
  }

  // Additional small/caption and error styles
  static TextStyle captionStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: isNarrow(context) ? 10.0 : 12.0,
      fontWeight: weight ?? FontWeight.normal,
      color: color ?? Colors.grey[600],
    );
  }

  static TextStyle errorStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: contentFontSize(context),
      fontWeight: weight ?? FontWeight.w600,
      color: color ?? Colors.red,
    );
  }

  // Produce a TextTheme based on UIValue helpers for use in ThemeData
  static TextTheme textTheme(BuildContext context) {
    final base = ThemeData.light().textTheme;
    return base.copyWith(
      titleLarge: titleStyle(context),
      titleMedium: subtitleStyle(context),
      bodyLarge: contentStyle(context),
      bodyMedium: contentStyle(context),
      labelLarge: buttonStyle(context),
      bodySmall: captionStyle(context),
    );
  }

  // App-wide ThemeData builder that uses the UIValue textTheme
  static ThemeData appTheme(BuildContext context) {
    final colorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue);
    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      textTheme: textTheme(context),
      appBarTheme: AppBarTheme(titleTextStyle: titleStyle(context)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
      ),
    );
  }

  static double dynamicVerticalSpacing(BuildContext context) {
    return isNarrow(context) ? 12.0 : 20.0;
  }

  static double smallVerticalSpacing(BuildContext context) =>
      dynamicVerticalSpacing(context) * 0.4;
}
