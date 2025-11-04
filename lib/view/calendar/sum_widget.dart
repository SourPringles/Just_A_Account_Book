import 'package:flutter/material.dart';
import '../uivalue/ui_layout.dart';
import '../uivalue/ui_colors.dart';

// UI 타입을 나타내는 enum (calendar_widget.dart와 동일)
enum SumWidgetUIType { mobile, window, dev }

class SumWidget extends StatelessWidget {
  final int currentMonth;
  final int monthIncome;
  final int monthExpense;
  final int weeklyTotal;
  final int monthlyTotal;
  final SumWidgetUIType uiType; // UI 타입

  const SumWidget({
    super.key,
    // TEST VALUE
    required this.currentMonth,
    required this.monthIncome,
    required this.monthExpense,
    required this.weeklyTotal,
    required this.monthlyTotal,
    this.uiType = SumWidgetUIType.mobile, // 기본값은 모바일
  });

  // UI 타입에 따른 텍스트 크기 설정
  double _getTitleFontSize() {
    switch (uiType) {
      case SumWidgetUIType.window:
        return 18.0;
      case SumWidgetUIType.dev:
        return 14.0;
      case SumWidgetUIType.mobile:
        return 16.0;
    }
  }

  double _getItemFontSize() {
    switch (uiType) {
      case SumWidgetUIType.window:
        return 22.0;
      case SumWidgetUIType.dev:
        return 16.0;
      case SumWidgetUIType.mobile:
        return 20.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$currentMonth 월',
          style: TextStyle(
            fontSize: _getTitleFontSize(),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: UILayout.smallGap),
        CommonSumWidget(
          val: monthIncome,
          label: '수입',
          color: UIColors.incomeColor,
          fontSize: _getItemFontSize(),
        ),
        SizedBox(height: UILayout.smallGap),
        CommonSumWidget(
          val: monthExpense,
          label: '지출',
          color: UIColors.expenseColor,
          fontSize: _getItemFontSize(),
        ),
        SizedBox(height: UILayout.smallGap),
        CommonSumWidget(
          val: monthlyTotal,
          label: '월간 합계',
          color: UIColors.textPrimaryColor(context),
          fontSize: _getItemFontSize(),
        ),
      ],
    );
  }
}

// 합계 위젯
class CommonSumWidget extends StatelessWidget {
  final int val;
  final String label;
  final Color color;
  final double fontSize;

  const CommonSumWidget({
    super.key,
    required this.val,
    required this.label,
    required this.color,
    this.fontSize = 20.0, // 기본 폰트 크기
  });

  @override
  Widget build(BuildContext context) {
    // 금액을 포맷팅하는 함수
    String formatCurrency(int amount) {
      final absAmount = amount.abs();
      if (absAmount >= 10000) {
        final manWon = absAmount / 10000;
        return '${manWon.toStringAsFixed(manWon % 1 == 0 ? 0 : 1)}만원';
      } else if (absAmount >= 1000) {
        final cheonWon = absAmount / 1000;
        return '${cheonWon.toStringAsFixed(cheonWon % 1 == 0 ? 0 : 1)}천원';
      } else {
        return '$absAmount원';
      }
    }

    final amount = val;

    // 수입/지출에 따른 부호와 색상 결정
    String getPrefix() {
      if (label == '지출') return '-';
      if (label == '수입') return '+';
      return amount >= 0 ? '+' : '-';
    }

    final formattedAmount = formatCurrency(amount);
    final prefix = getPrefix();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: UIColors.whiteColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color, width: 1),
        //boxShadow: [
        //  BoxShadow(color: color, blurRadius: 3.0, offset: const Offset(0, 2)),
        //],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: UIColors.mutedTextColor(context),
            ),
          ),
          const Spacer(),
          Text(
            '$prefix$formattedAmount',
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
