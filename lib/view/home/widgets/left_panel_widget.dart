import 'package:flutter/material.dart';
import '../../uivalue/ui_layout.dart';
import '../../calendar/calendar_widget.dart';

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
            color: Colors.grey.shade300,
            width: UILayout.borderWidthNormal,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(UILayout.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CalendarWidget(
              initialSelectedDate: selectedDate,
              refreshTrigger: refreshTrigger,
              uiType: CalendarUIType.window,
              onDateSelected: onDateSelected,
            ),
            SizedBox(height: UILayout.smallGap),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
