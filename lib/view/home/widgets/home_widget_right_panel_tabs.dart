import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_text.dart';
import '../../uivalue/ui_colors.dart';

class RightPanelTabsWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const RightPanelTabsWidget({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(UILayout.smallGap),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        // removed bottom border for a cleaner right-panel header
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              index: 0,
              label: l10n.transactions,
              icon: Icons.list,
              isSelected: currentIndex == 0,
              onTap: () => onTabSelected(0),
            ),
          ),
          SizedBox(width: UILayout.smallGap),
          Expanded(
            child: _TabButton(
              index: 1,
              label: l10n.summary,
              icon: Icons.analytics,
              isSelected: currentIndex == 1,
              onTap: () => onTabSelected(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final int index;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.index,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: UILayout.smallGap,
          horizontal: UILayout.smallGap,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : UIColors.transparentColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: UILayout.iconSizeSmall,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : UIColors.textPrimaryColor(context),
            ),
            SizedBox(width: UILayout.tinyGap),
            Text(
              label,
              style: UIText.mediumTextStyle(
                context,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : UIColors.textPrimaryColor(context),
                weight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
