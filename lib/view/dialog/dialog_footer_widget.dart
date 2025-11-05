import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../uivalue/ui_layout.dart';
import '../uivalue/ui_colors.dart';

class DialogFooterWidget extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const DialogFooterWidget({
    super.key,
    required this.onClose,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 왼쪽: 삭제 버튼
        if (onDelete != null)
          TextButton(
            onPressed: onDelete,
            child: Text(
              l10n.delete,
              style: TextStyle(color: UIColors.commonNegativeColor),
            ),
          )
        else
          const SizedBox.shrink(),

        // 오른쪽: 수정 및 닫기 버튼
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null) ...[
              TextButton(onPressed: onEdit, child: Text(l10n.edit)),
              SizedBox(width: UILayout.smallGap),
            ],
            TextButton(onPressed: onClose, child: Text(l10n.close)),
          ],
        ),
      ],
    );
  }
}
