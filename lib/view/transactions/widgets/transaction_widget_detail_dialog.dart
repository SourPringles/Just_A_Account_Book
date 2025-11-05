import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_colors.dart';
import '../../dialog/dialog_header_widget.dart';
import '../../dialog/dialog_footer_widget.dart';

/// 거래 내역 상세 정보를 보여주는 다이얼로그 위젯
class TransactionWidgetDetailDialog extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TransactionWidgetDetailDialog({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(UILayout.dialogPadding),
        constraints: BoxConstraints(maxWidth: UILayout.dialogMaxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialogHeaderWidget(
              title: transaction.category,
              onClose: () => Navigator.of(context).pop(),
            ),
            const Divider(),
            SizedBox(height: UILayout.largeGap),
            _buildDetailRow(
              '구분',
              transaction.type == TransactionType.income ? '수입' : '지출',
            ),
            _buildDetailRow(
              '금액',
              '₩${NumberFormat('#,###').format(transaction.amount)}',
            ),
            _buildDetailRow('카테고리', transaction.category),
            if (transaction.description.isNotEmpty)
              _buildDetailRow('설명', transaction.description),
            _buildDetailRow(
              '날짜',
              DateFormat('yyyy년 MM월 dd일').format(transaction.date),
            ),
            SizedBox(height: UILayout.largeGap),
            DialogFooterWidget(
              onClose: () => Navigator.of(context).pop(),
              onEdit: () {
                Navigator.of(context).pop();
                onEdit();
              },
              onDelete: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Builder(
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: UILayout.tinyGap),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: UILayout.transactionLabelWidth,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: UIColors.mutedTextColor(context),
                ),
              ),
            ),
            const Text(': '),
            Expanded(child: Text(value)),
          ],
        ),
      ),
    );
  }
}
