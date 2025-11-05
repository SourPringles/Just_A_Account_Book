import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../../utils/currency_formatter.dart';
import '../../uivalue/ui_colors.dart';

/// 합계를 표시하는 공통 위젯
class CalendarSummaryWidget extends StatelessWidget {
  final int val;
  final String label;
  final Color color;
  final double fontSize;

  const CalendarSummaryWidget({
    super.key,
    required this.val,
    required this.label,
    required this.color,
    this.fontSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final amount = val;

    // 수입/지출에 따른 부호와 색상 결정
    String getPrefix() {
      if (label == l10n.expense) return '-';
      if (label == l10n.income) return '+';
      return amount >= 0 ? '+' : '-';
    }

    final formattedAmount = CurrencyFormatter.formatWithUnit(amount, l10n);
    final prefix = getPrefix();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: UIColors.whiteColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color, width: 1),
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
