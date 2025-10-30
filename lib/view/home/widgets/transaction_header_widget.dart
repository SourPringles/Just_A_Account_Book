import 'package:flutter/material.dart';
import '../../uivalue.dart';

class TransactionHeaderWidget extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onAdd;

  const TransactionHeaderWidget({
    super.key,
    required this.selectedDate,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UIValue.defaultPadding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: UIValue.borderWidthNormal,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long,
            color: Colors.blue,
            size: UIValue.iconSizeXL / 2.666,
          ),
          SizedBox(width: UIValue.smallGap),
          Text(
            '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
            style: UIValue.titleStyle(context),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: Icon(Icons.add, size: UIValue.iconSizeSmall),
            label: const Text('거래 추가'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: UIValue.smallGap * 2,
                vertical: UIValue.smallGap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
