import 'package:flutter/material.dart';

class SumWidget extends StatelessWidget {
  final int currentMonth;
  final int monthIncome;
  final int monthExpense;
  final int weeklyTotal;
  final int monthlyTotal;

  const SumWidget({
    super.key,
    // TEST VALUE
    required this.currentMonth,
    required this.monthIncome,
    required this.monthExpense,
    required this.weeklyTotal,
    required this.monthlyTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$currentMonth 월',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CommonSumWidget(val: monthIncome, label: '수입', color: Colors.green),
        const SizedBox(height: 8),
        CommonSumWidget(val: monthExpense, label: '지출', color: Colors.red),
        const SizedBox(height: 8),
        CommonSumWidget(val: monthlyTotal, label: '월간 합계', color: Colors.black),
      ],
    );
  }
}

// 합계 위젯
class CommonSumWidget extends StatelessWidget {
  final int val;
  final String label;
  final Color color;

  const CommonSumWidget({
    super.key,
    required this.val,
    required this.label,
    required this.color,
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
        return '${absAmount}원';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color, width: 1),
        //boxShadow: [
        //  BoxShadow(color: color, blurRadius: 3.0, offset: const Offset(0, 2)),
        //],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const Spacer(),
          Text(
            '$prefix$formattedAmount',
            style: TextStyle(
              fontSize: 12,
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
