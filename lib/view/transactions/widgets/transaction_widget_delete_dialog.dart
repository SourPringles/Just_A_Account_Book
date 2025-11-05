import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/transaction_model.dart';
import '../../../services/transaction_service.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_text.dart';
import '../../dialog/dialog_header_widget.dart';

/// 거래 내역 삭제 확인 다이얼로그 위젯
class TransactionWidgetDeleteDialog extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDeleted;

  const TransactionWidgetDeleteDialog({
    super.key,
    required this.transaction,
    required this.onDeleted,
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
              title: '거래 내역 삭제',
              onClose: () => Navigator.of(context).pop(),
            ),
            const Divider(),
            SizedBox(height: UILayout.largeGap),
            Text('${transaction.category} 거래 내역을 삭제하시겠습니까?'),
            SizedBox(height: UILayout.largeGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                SizedBox(width: UILayout.smallGap),
                TextButton(
                  onPressed: () => _handleDelete(context),
                  child: Text('삭제', style: UIText.errorStyle(context)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && transaction.id != null) {
        await TransactionService.deleteTransaction(
          userId: user.uid,
          transactionId: transaction.id!,
        );
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('거래 내역이 삭제되었습니다')),
          );
          onDeleted();
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }
}
