import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../../models/transaction_model.dart';
import '../../../services/settings_service.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_colors.dart';
import '../../uivalue/ui_text.dart';
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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(UILayout.dialogPadding),
        constraints: BoxConstraints(maxWidth: UILayout.dialogMaxWidth),
        decoration: BoxDecoration(
          color: UIColors.backgroundColor(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DialogHeaderWidget(
                title: transaction.category,
                onClose: () => Navigator.of(context).pop(),
              ),
              const Divider(),
              SizedBox(height: UILayout.largeGap),

              // Amount (prominent)
              Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: SettingsService.instance.currencySymbol,
                      builder: (context, currencySymbol, _) {
                        return Text(
                          '${transaction.type == TransactionType.income ? '+' : '-'}$currencySymbol${NumberFormat('#,###').format(transaction.amount)}',
                          style: TextStyle(
                            fontSize: UIText.calendarSumFontSize,
                            fontWeight: FontWeight.bold,
                            color: transaction.type == TransactionType.income
                                ? UIColors.incomeColor
                                : UIColors.expenseColor,
                          ),
                        );
                      },
                    ),
                  ),
                  Chip(
                    backgroundColor: UIColors.cardBackground(context),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? UIColors.transparentColor
                            : UIColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    label: Text(
                      transaction.type == TransactionType.income
                          ? l10n.income
                          : l10n.expense,
                      style: TextStyle(
                        color: transaction.type == TransactionType.income
                            ? UIColors.incomeColor
                            : UIColors.expenseColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: UILayout.smallGap),

              // Category
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Chip(
                          label: Text(
                            transaction.category,
                            style: TextStyle(
                              color: UIColors.textPrimaryColor(context),
                            ),
                          ),
                          backgroundColor: UIColors.cardBackground(context),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? UIColors.transparentColor
                                  : UIColors.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: UILayout.smallGap),

              // Description
              if (transaction.description.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.description,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: UIColors.mutedTextColor(context),
                      ),
                    ),
                    SizedBox(height: UILayout.tinyGap),
                    Text(
                      transaction.description,
                      style: TextStyle(color: UIColors.mutedTextColor(context)),
                    ),
                    SizedBox(height: UILayout.smallGap),
                  ],
                ),

              // Date (shown inside a chip/card like category)
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Chip(
                          avatar: Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: UIColors.textPrimaryColor(context),
                          ),
                          label: Text(
                            DateFormat(
                              'yyyy - MM - dd',
                            ).format(transaction.date),
                            style: TextStyle(
                              color: UIColors.textPrimaryColor(context),
                            ),
                          ),
                          backgroundColor: UIColors.cardBackground(context),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? UIColors.transparentColor
                                  : UIColors.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
      ),
    );
  }

  // NOTE: detail rows rendered inline in build() now; helper removed.
}
