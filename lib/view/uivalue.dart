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

  // ========== 폰트 크기 정의 (4단계) ==========
  // 날짜 폰트 크기 < 작은 폰트 크기 < 중간 폰트 크기 < 큰 폰트 크기
  
  static const double dateFontSize = 10.0; // 날짜 폰트 크기 (캘린더 날짜 등)
  static const double smallFontSize = 12.0; // 작은 폰트 크기 (트랜잭션 위젯 내용, 트랜잭션 상세보기 창 내부 등)
  static const double mediumFontSize = 16.0; // 중간 폰트 크기 (캘린더 연/월, 트랜잭션 위젯 제목 등)
  static const double largeFontSize = 20.0; // 큰 폰트 크기 (페이지 제목 등)

  // ========== 폰트 패밀리 정의 ==========
  // 앱 전체에서 사용할 폰트를 여기서 수정 가능
  static const String fontFamily = ''; // 기본 시스템 폰트 사용 (수정 가능)
  
  // ========== 폰트 무게(Weight) 정의 ==========
  static const FontWeight fontWeightNormal = FontWeight.normal; // 일반 텍스트
  static const FontWeight fontWeightMedium = FontWeight.w600; // 강조 텍스트
  static const FontWeight fontWeightBold = FontWeight.bold; // 제목 텍스트

  // ========== TextStyle 헬퍼 메서드 ==========
  
  // 날짜 스타일 (캘린더 날짜 등)
  static TextStyle dateStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: dateFontSize,
      fontWeight: weight ?? fontWeightNormal,
      color: color ?? textPrimaryColor(context),
      fontFamily: fontFamily.isEmpty ? null : fontFamily,
    );
  }

  // 작은 텍스트 스타일 (트랜잭션 위젯 내용, 상세보기 창 내부 등)
  static TextStyle smallTextStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: smallFontSize,
      fontWeight: weight ?? fontWeightNormal,
      color: color ?? textPrimaryColor(context),
      fontFamily: fontFamily.isEmpty ? null : fontFamily,
    );
  }

  // 중간 텍스트 스타일 (캘린더 연/월, 트랜잭션 위젯 제목 등)
  static TextStyle mediumTextStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: mediumFontSize,
      fontWeight: weight ?? fontWeightMedium,
      color: color ?? textPrimaryColor(context),
      fontFamily: fontFamily.isEmpty ? null : fontFamily,
    );
  }

  // 큰 텍스트 스타일 (페이지 제목 등)
  static TextStyle largeTextStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: largeFontSize,
      fontWeight: weight ?? fontWeightBold,
      color: color ?? textPrimaryColor(context),
      fontFamily: fontFamily.isEmpty ? null : fontFamily,
    );
  }

  // ========== 기존 호환성을 위한 별칭 메서드 ==========
  // 기존 코드와의 호환성을 위해 유지 (추후 점진적으로 새로운 메서드로 교체)
  
  static TextStyle titleStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) => largeTextStyle(context, color: color, weight: weight);

  static TextStyle subtitleStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) => mediumTextStyle(context, color: color, weight: weight);

  static TextStyle labelStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) => mediumTextStyle(context, color: color, weight: weight);

  static TextStyle contentStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) => smallTextStyle(context, color: color, weight: weight);

  static TextStyle buttonStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) => mediumTextStyle(context, color: color, weight: weight);

  // Additional small/caption and error styles
  static TextStyle captionStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: dateFontSize,
      fontWeight: weight ?? fontWeightNormal,
      color: color ?? mutedTextColor(context),
      fontFamily: fontFamily.isEmpty ? null : fontFamily,
    );
  }

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

  // Theme-aware text color helpers
  static Color textPrimaryColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkDefaultTextColor : lightDefaultTextColor;
  }

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

  // Weekend specific colors
  static Color saturdayTextColor(BuildContext context) => Colors.blue;
  static Color sundayTextColor(BuildContext context) => Colors.red;

  // Helper to pick weekday color (DateTime.weekday: Mon=1 .. Sun=7)
  static Color weekdayTextColor(BuildContext context, int weekday) {
    if (weekday == DateTime.saturday) return saturdayTextColor(context);
    if (weekday == DateTime.sunday) return sundayTextColor(context);
    return weekdayDateTextColor(context); // 평일은 새로 정의한 색상 사용
  }

  // Colors related to surfaces/primary backgrounds
  static Color onPrimaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;
  static Color onSurfaceColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static TextStyle errorStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: smallFontSize,
      fontWeight: weight ?? fontWeightMedium,
      color: color ?? commonDeleteCancelColor,
      fontFamily: fontFamily.isEmpty ? null : fontFamily,
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
      scaffoldBackgroundColor: lightBackgroundColor, // Light 모드 배경색
      textTheme: textTheme(context),
      appBarTheme: AppBarTheme(titleTextStyle: titleStyle(context)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: commonButtonColor, // 공통 버튼 색상
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
        backgroundColor: commonButtonColor, // 공통 버튼 색상
      ),
      scaffoldBackgroundColor: darkBackgroundColor, // Dark 모드 배경색
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
