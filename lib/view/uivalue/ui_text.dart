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

  // ========== 캘린더 전용 폰트 크기 정의 ==========
  
  static const double calendarDayNumber = mediumFontSize; // 캘린더 날짜 숫자
  static const double calendarAmount = smallFontSize; // 캘린더 금액
  static const double calendarHeader = mediumFontSize; // 캘린더 헤더
  static const double calendarDayOfWeek = mediumFontSize - 2; // 캘린더 요일
  static const double calendarRowHeight = 75.0; // 캘린더 행 높이
  static const double calendarSumFontSize = 22.0; // 캘린더 합계 폰트 크기
  
  // 거래 관련 폰트 크기
  static const double transactionAmountSize = 14.0; // 거래 금액 폰트 크기
  static const double transactionBalanceSize = 16.0; // 거래 잔액 폰트 크기

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
      color: color ?? UIColors.commonNegativeColor,
      fontFamily: fontFamily.isEmpty ? null : fontFamily,
    );
  }
}
