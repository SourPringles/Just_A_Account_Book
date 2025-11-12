import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import '../../../services/settings_service.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_colors.dart';
import '../../uivalue/ui_text.dart';

/// 거래 항목을 카드 형태로 표시하는 위젯
class TransactionWidgetItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const TransactionWidgetItem({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? UIColors.incomeColor : UIColors.expenseColor;
    final icon = isIncome ? Icons.add_circle : Icons.remove_circle;
  // currencySymbol is a ValueNotifier so use a ValueListenableBuilder where needed

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: UILayout.smallGap,
        vertical: UILayout.tinyGap,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(26),
          child: Icon(icon, color: color),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                transaction.category,
                style: UIText.mediumTextStyle(context, weight: FontWeight.bold),
              ),
            ),
            ValueListenableBuilder<String>(
              valueListenable: SettingsService.instance.currencySymbol,
              builder: (context, currencySymbol, _) {
                return Text(
                  '${isIncome ? '+' : '-'}$currencySymbol${NumberFormat('#,###').format(transaction.amount)}',
                  style: UIText.mediumTextStyle(
                    context,
                    color: color,
                    weight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.description.isNotEmpty) ...[
              SizedBox(height: UILayout.tinyGap),
              Text(
                transaction.description,
                style: UIText.smallTextStyle(context),
              ),
            ],
            SizedBox(height: UILayout.tinyGap),
            Text(
              DateFormat('MM월 dd일').format(transaction.date),
              style: UIText.smallTextStyle(
                context,
              ).copyWith(color: UIColors.mutedTextColor(context)),
            ),
          ],
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
