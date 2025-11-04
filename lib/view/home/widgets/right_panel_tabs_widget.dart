import 'package:flutter/material.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_text.dart';

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
    return Container(
      padding: EdgeInsets.all(UILayout.smallGap),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: UILayout.borderWidthNormal,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              index: 0,
              label: '거래내역',
              icon: Icons.list,
              isSelected: currentIndex == 0,
              onTap: () => onTabSelected(0),
            ),
          ),
          SizedBox(width: UILayout.smallGap),
          Expanded(
            child: _TabButton(
              index: 1,
              label: '요약',
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
              : Colors.transparent,
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
                  : (() {
                      final c = Theme.of(context).colorScheme.onSurface;
                      final r = (c.r * 255.0).round() & 0xff;
                      final g = (c.g * 255.0).round() & 0xff;
                      final b = (c.b * 255.0).round() & 0xff;
                      return Color.fromRGBO(r, g, b, 0.7);
                    })(),
            ),
            SizedBox(width: UILayout.tinyGap),
            Text(
              label,
              style: UIText.subtitleStyle(
                context,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : (() {
                        final c = Theme.of(context).colorScheme.onSurface;
                        final r = (c.r * 255.0).round() & 0xff;
                        final g = (c.g * 255.0).round() & 0xff;
                        final b = (c.b * 255.0).round() & 0xff;
                        return Color.fromRGBO(r, g, b, 0.8);
                      })(),
                weight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
