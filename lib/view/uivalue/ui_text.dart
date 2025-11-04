import 'package:flutter/material.dart';
import 'ui_colors.dart';

/// UI 텍스트 관련 정의
/// 폰트 크기, 폰트 패밀리, 텍스트 스타일 등을 정의합니다.
class UIText {
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
      color: color ?? UIColors.textPrimaryColor(context),
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
      color: color ?? UIColors.textPrimaryColor(context),
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
      color: color ?? UIColors.textPrimaryColor(context),
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
      color: color ?? UIColors.textPrimaryColor(context),
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

  // Caption 스타일 (작은 부가 정보)
  static TextStyle captionStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: dateFontSize,
      fontWeight: weight ?? fontWeightNormal,
      color: color ?? UIColors.mutedTextColor(context),
      fontFamily: fontFamily.isEmpty ? null : fontFamily,
    );
  }

  // 에러 스타일
  static TextStyle errorStyle(
    BuildContext context, {
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: smallFontSize,
      fontWeight: weight ?? fontWeightMedium,
      color: color ?? UIColors.commonDeleteCancelColor,
      fontFamily: fontFamily.isEmpty ? null : fontFamily,
    );
  }
}
