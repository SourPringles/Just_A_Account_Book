import 'package:flutter/material.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_text.dart';
import '../../uivalue/ui_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../services/transaction_service.dart';

class MonthlySummaryWidget extends StatelessWidget {
  final DateTime month;

  const MonthlySummaryWidget({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<Map<String, double>>(
      future: TransactionService.getMonthlyTotals(
        userId: user.uid,
        month: month,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(UILayout.defaultPadding),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(UILayout.defaultPadding),
              child: Text('오류가 발생했습니다: ${snapshot.error}'),
            ),
          );
        }

        final totals =
            snapshot.data ?? {'income': 0, 'expense': 0, 'balance': 0};
        final income = totals['income'] ?? 0;
        final expense = totals['expense'] ?? 0;
        final balance = totals['balance'] ?? 0;

        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(
            horizontal: UILayout.smallGap,
            vertical: UILayout.tinyGap,
          ),
          child: Padding(
            padding: EdgeInsets.all(UILayout.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('yyyy년 MM월').format(month),
                      style: UIText.mediumTextStyle(
                        context,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      balance >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: balance >= 0 ? UIColors.incomeColor : UIColors.expenseColor,
                    ),
                  ],
                ),
                const Divider(),
                SizedBox(height: UILayout.smallGap),

                // 수입
                _buildSummaryRow(
                  context,
                  '수입',
                  income,
                  UIColors.incomeColor,
                  Icons.add_circle,
                ),
                SizedBox(height: UILayout.smallGap),

                // 지출
                _buildSummaryRow(
                  context,
                  '지출',
                  expense,
                  UIColors.expenseColor,
                  Icons.remove_circle,
                ),
                SizedBox(height: UILayout.smallGap),

                const Divider(),

                // 잔액
                _buildSummaryRow(
                  context,
                  '잔액',
                  balance,
                  balance >= 0 ? UIColors.balancePositiveColor : UIColors.balanceNegativeColor,
                  balance >= 0 ? Icons.account_balance_wallet : Icons.warning,
                  isBalance: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    double amount,
    Color color,
    IconData icon, {
    bool isBalance = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: UILayout.iconSizeMedium),
        SizedBox(width: UILayout.smallGap),
        Text(
          label,
          style: UIText.mediumTextStyle(
            context,
            weight: isBalance ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          '${amount >= 0 ? '+' : ''}₩${NumberFormat('#,###').format(amount.abs())}',
          style: TextStyle(
            fontSize: isBalance ? UIText.transactionBalanceSize : UIText.transactionAmountSize,
            fontWeight: isBalance ? FontWeight.bold : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
