import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../services/transaction_service.dart';

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
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('yyyy년 MM월').format(month),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      balance >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: balance >= 0 ? Colors.green : Colors.red,
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),

                // 수입
                _buildSummaryRow('수입', income, Colors.green, Icons.add_circle),
                const SizedBox(height: 8),

                // 지출
                _buildSummaryRow(
                  '지출',
                  expense,
                  Colors.red,
                  Icons.remove_circle,
                ),
                const SizedBox(height: 8),

                const Divider(),

                // 잔액
                _buildSummaryRow(
                  '잔액',
                  balance,
                  balance >= 0 ? Colors.blue : Colors.orange,
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
    String label,
    double amount,
    Color color,
    IconData icon, {
    bool isBalance = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: isBalance ? 16 : 14,
            fontWeight: isBalance ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          '${amount >= 0 ? '+' : ''}₩${NumberFormat('#,###').format(amount.abs())}',
          style: TextStyle(
            fontSize: isBalance ? 16 : 14,
            fontWeight: isBalance ? FontWeight.bold : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
