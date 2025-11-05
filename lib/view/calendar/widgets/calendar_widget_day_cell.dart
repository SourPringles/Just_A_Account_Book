import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_colors.dart';
import '../../uivalue/ui_text.dart';

/// 캘린더 날짜 셀 위젯
class CalendarDayCellWidget extends StatelessWidget {
  final DateTime date;
  final Map<String, double> dailyTotals;
  final bool isSelected;
  final bool isToday;

  const CalendarDayCellWidget({
    super.key,
    required this.date,
    required this.dailyTotals,
    this.isSelected = false,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    // 요일에 따른 날짜 색상 설정
    Color dateTextColor = UIColors.textPrimaryColor(context);
    if (date.weekday == DateTime.sunday) {
      dateTextColor = UIColors.sundayTextColor(context);
    } else if (date.weekday == DateTime.saturday) {
      dateTextColor = UIColors.saturdayTextColor(context);
    }

    final income = dailyTotals['income'] ?? 0;
    final expense = dailyTotals['expense'] ?? 0;

    // 금액을 간단한 형태로 포맷 (천원 단위)
    String formatAmount(double amount) {
      if (amount == 0) return '';
      if (amount >= 10000) {
        return '${NumberFormat('#.#').format(amount / 10000)}만';
      } else if (amount >= 1000) {
        return '${(amount / 1000).toInt()}천';
      } else {
        return amount.toInt().toString();
      }
    }

    Widget cellContent = Container(
      margin: EdgeInsets.all(UILayout.tinyGap),
      decoration: BoxDecoration(
        border: Border.all(
          color: UIColors.borderColor,
          width: UILayout.borderWidthThin,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 날짜 영역
          Container(
            height: 20,
            alignment: Alignment.topLeft,
            child: Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: UIText.calendarDayNumber,
                fontWeight: FontWeight.w500,
                color: dateTextColor,
              ),
            ),
          ),
          // 거래 금액 영역 (수입/지출)
          Expanded(
            child: Container(
              margin: EdgeInsets.all(UILayout.tinyGap / 2),
              padding: EdgeInsets.all(UILayout.tinyGap),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 수입 (파란색)
                  Text(
                    income > 0 ? '+${formatAmount(income)}' : '',
                    style: TextStyle(
                      fontSize: UIText.calendarAmount,
                      color: UIColors.incomeColor,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // 지출 (빨간색)
                  Text(
                    expense > 0 ? '-${formatAmount(expense)}' : '',
                    style: TextStyle(
                      fontSize: UIText.calendarAmount,
                      color: UIColors.expenseColor,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // 선택된 날짜는 그림자 추가
    if (isSelected) {
      return Stack(
        children: [
          cellContent,
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(UILayout.tinyGap / 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: UIColors.shadowColor,
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // 오늘 날짜는 주황색 테두리 추가
    if (isToday) {
      return Stack(
        children: [
          cellContent,
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(UILayout.tinyGap / 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: UIColors.todayBorderColor,
                  width: UILayout.borderWidthNormal,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      );
    }

    return cellContent;
  }
}
