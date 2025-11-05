import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_text.dart';
import '../../uivalue/ui_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../services/transaction_service.dart';
import '../../../services/settings_service.dart';

class MonthlySummaryWidget extends StatelessWidget {
  final DateTime month;

  const MonthlySummaryWidget({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
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
              child: Text('${l10n.errorOccurred}: ${snapshot.error}'),
            ),
          );
        }

        final totals =
            snapshot.data ?? {'income': 0, 'expense': 0, 'balance': 0};
        final income = totals['income'] ?? 0;
        final expense = totals['expense'] ?? 0;
        final balance = totals['balance'] ?? 0;

        // 날짜 포맷 (언어별)
        final dateFormat = locale.languageCode == 'ko' 
            ? DateFormat('yyyy년 MM월', locale.toString())
            : DateFormat('MMM yyyy', locale.toString());

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
                      dateFormat.format(month),
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
                  l10n.income,
                  income,
                  UIColors.incomeColor,
                  Icons.add_circle,
                  isIncome: true,
                ),
                SizedBox(height: UILayout.smallGap),

                // 지출
                _buildSummaryRow(
                  context,
                  l10n.expense,
                  expense,
                  UIColors.expenseColor,
                  Icons.remove_circle,
                  isExpense: true,
                ),
                SizedBox(height: UILayout.smallGap),

                const Divider(),

                // 잔액
                _buildSummaryRow(
                  context,
                  l10n.balance,
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
    num amount, // double에서 num으로 변경 (int와 double 모두 지원)
    Color color,
    IconData icon, {
    bool isBalance = false,
    bool isIncome = false,
    bool isExpense = false,
  }) {
    final currencySymbol = SettingsService.instance.currencySymbol.value;
    
    // 부호 결정
    String prefix = '';
    if (isIncome && amount > 0) {
      prefix = '+';
    } else if (isExpense && amount > 0) {
      prefix = '-';
    } else if (isBalance) {
      prefix = amount >= 0 ? '+' : '-';
    }
    
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
          '$prefix$currencySymbol${NumberFormat('#,###').format(amount.abs())}',
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
