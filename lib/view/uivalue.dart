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
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      textTheme: textTheme(context),
      appBarTheme: AppBarTheme(titleTextStyle: titleStyle(context)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
      ),
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: buttonPadding(context),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: buttonStyle(context),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
        ),
      ),
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: (() {
              final c = colorScheme.onSurface;
              final r = (c.r * 255.0).round() & 0xff;
              final g = (c.g * 255.0).round() & 0xff;
              final b = (c.b * 255.0).round() & 0xff;
              return Color.fromRGBO(r, g, b, 0.12);
            })(),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: (() {
              final c = colorScheme.onSurface;
              final r = (c.r * 255.0).round() & 0xff;
              final g = (c.g * 255.0).round() & 0xff;
              final b = (c.b * 255.0).round() & 0xff;
              return Color.fromRGBO(r, g, b, 0.12);
            })(),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        labelStyle: labelStyle(context),
      ),
      // Cards/ListTiles
      cardTheme: base.cardTheme.copyWith(
        color: colorScheme.surface,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurface,
        textColor: colorScheme.onSurface,
      ),
      // Icon theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: iconSizeMedium,
      ),
      // Toggle buttons
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: colorScheme.onSurface,
        selectedColor: colorScheme.onPrimary,
        fillColor: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Dark theme counterpart
  static ThemeData darkTheme(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    );
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      textTheme: textTheme(
        context,
      ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: titleStyle(context, color: Colors.white),
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: Colors.blue,
      ),
      scaffoldBackgroundColor: Colors.black,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: buttonPadding(context),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          textStyle: buttonStyle(context, color: colorScheme.onPrimary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          side: BorderSide(
            color: (() {
              final c = colorScheme.onPrimary;
              final r = (c.r * 255.0).round() & 0xff;
              final g = (c.g * 255.0).round() & 0xff;
              final b = (c.b * 255.0).round() & 0xff;
              return Color.fromRGBO(r, g, b, 0.12);
            })(),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: (() {
              final c = colorScheme.onSurface;
              final r = (c.r * 255.0).round() & 0xff;
              final g = (c.g * 255.0).round() & 0xff;
              final b = (c.b * 255.0).round() & 0xff;
              return Color.fromRGBO(r, g, b, 0.12);
            })(),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: (() {
              final c = colorScheme.onSurface;
              final r = (c.r * 255.0).round() & 0xff;
              final g = (c.g * 255.0).round() & 0xff;
              final b = (c.b * 255.0).round() & 0xff;
              return Color.fromRGBO(r, g, b, 0.12);
            })(),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        labelStyle: labelStyle(context, color: colorScheme.onSurface),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      listTileTheme: base.listTileTheme.copyWith(
        iconColor: colorScheme.onSurface,
        textColor: colorScheme.onSurface,
      ),
      iconTheme: base.iconTheme.copyWith(
        color: colorScheme.onSurface,
        size: iconSizeMedium,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: colorScheme.onSurface,
        selectedColor: colorScheme.onPrimary,
        fillColor: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static double dynamicVerticalSpacing(BuildContext context) {
    return isNarrow(context) ? 12.0 : 20.0;
  }

  static double smallVerticalSpacing(BuildContext context) =>
      dynamicVerticalSpacing(context) * 0.4;
}
