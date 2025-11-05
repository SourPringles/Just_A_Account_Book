import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_text.dart';
import '../../uivalue/ui_colors.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(UILayout.defaultPadding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: UIColors.borderColor,
            width: UILayout.borderWidthNormal,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long,
            color: UIColors.commonPositiveColor,
            size: UILayout.iconSizeXL / 2.666,
          ),
          SizedBox(width: UILayout.smallGap),
          Text(
            l10n.dateFormat(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
            ),
            style: UIText.largeTextStyle(context),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: Icon(Icons.add, size: UILayout.iconSizeSmall),
            label: Text(l10n.addTransaction),
            style: ElevatedButton.styleFrom(
              backgroundColor: UIColors.commonPositiveColor,
              foregroundColor: UIColors.whiteColor,
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
