import 'package:flutter/material.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_text.dart';

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
      padding: EdgeInsets.all(UILayout.defaultPadding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: UILayout.borderWidthNormal,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long,
            color: Colors.blue,
            size: UILayout.iconSizeXL / 2.666,
          ),
          SizedBox(width: UILayout.smallGap),
          Text(
            '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
            style: UIText.titleStyle(context),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: Icon(Icons.add, size: UILayout.iconSizeSmall),
            label: const Text('거래 추가'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: UILayout.smallGap * 2,
                vertical: UILayout.smallGap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
