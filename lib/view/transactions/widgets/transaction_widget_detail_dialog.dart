import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../../models/transaction_model.dart';
import '../../../services/settings_service.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final currencySymbol = SettingsService.instance.currencySymbol.value;
    
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
              context,
              l10n.type,
              transaction.type == TransactionType.income ? l10n.income : l10n.expense,
            ),
            _buildDetailRow(
              context,
              l10n.amount,
              '$currencySymbol${NumberFormat('#,###').format(transaction.amount)}',
            ),
            _buildDetailRow(context, l10n.category, transaction.category),
            if (transaction.description.isNotEmpty)
              _buildDetailRow(context, l10n.description, transaction.description),
            _buildDetailRow(
              context,
              l10n.date,
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

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
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
    );
  }
}
