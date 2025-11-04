import 'package:flutter/material.dart';

/// UI 레이아웃 관련 정의
/// 화면 크기, 간격, 패딩, 아이콘 크기, 테두리 등을 정의합니다.
class UILayout {
  // ========== 화면 크기 ==========
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // ========== 브레이크포인트 ==========
  static bool isNarrow(BuildContext context) => screenWidth(context) < 400;
  static bool isSmall(BuildContext context) => screenWidth(context) < 600;

  // ========== 공통 패딩(gap) ==========
  static const double tinyGap = 4.0;
  static const double smallGap = 8.0;
  static const double mediumGap = 15.0; // 기존 코드에서 자주 사용되는 15
  static const double largeGap = 16.0; // 기존 코드에서 16으로 쓰인 값
  static const double xlargeGap = 20.0;

  // ========== 기본 내부 여백 ==========
  static const double defaultPadding = 16.0;

  // ========== 다이얼로그 관련 ==========
  static const double dialogMaxWidth = 400.0;
  static const double dialogMaxHeight = 500.0;
  static const double dialogPadding = 24.0;

  // ========== 거래내역 라벨 너비 ==========
  static const double transactionLabelWidth = 60.0;

  // ========== 테두리 두께 ==========
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;

  // ========== 아이콘 크기 ==========
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXL = 64.0;

  // ========== 버튼/폼 관련 ==========
  static double buttonPadding(BuildContext context) =>
      isNarrow(context) ? 8.0 : 12.0;
  static double buttonSpacing(BuildContext context) =>
      isNarrow(context) ? 8.0 : 12.0;

  // ========== 동적 간격 ==========
  static double dynamicVerticalSpacing(BuildContext context) {
    return isNarrow(context) ? 12.0 : 20.0;
  }

  static double smallVerticalSpacing(BuildContext context) =>
      dynamicVerticalSpacing(context) * 0.4;
}
