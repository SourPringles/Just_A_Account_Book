import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    
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
              title: l10n.deleteTransaction,
              onClose: () => Navigator.of(context).pop(),
            ),
            const Divider(),
            SizedBox(height: UILayout.largeGap),
            Text(l10n.deleteTransactionConfirm(transaction.category)),
            SizedBox(height: UILayout.largeGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                SizedBox(width: UILayout.smallGap),
                TextButton(
                  onPressed: () => _handleDelete(context),
                  child: Text(l10n.delete, style: UIText.errorStyle(context)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
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
            SnackBar(content: Text(l10n.successTransactionDeleted)),
          );
          onDeleted();
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorDeleting}: $e')),
        );
      }
    }
  }
}
