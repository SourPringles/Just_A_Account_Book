import 'package:flutter/material.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_colors.dart';
import '../../calendar/calendar_page.dart';

class LeftPanelWidget extends StatelessWidget {
  final DateTime selectedDate;
  final int refreshTrigger;
  final int rightPanelIndex;
  final ValueChanged<DateTime> onDateSelected;

  const LeftPanelWidget({
    super.key,
    required this.selectedDate,
    required this.refreshTrigger,
    required this.rightPanelIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: UIColors.borderColor,
            width: UILayout.borderWidthNormal,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(UILayout.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Make the calendar take available vertical space to avoid overflow.
            Expanded(
              child: CalendarPage(
                initialSelectedDate: selectedDate,
                refreshTrigger: refreshTrigger,
                uiType: CalendarUIType.window,
                onDateSelected: onDateSelected,
              ),
            ),
            SizedBox(height: UILayout.smallGap),
          ],
        ),
      ),
    );
  }
}
