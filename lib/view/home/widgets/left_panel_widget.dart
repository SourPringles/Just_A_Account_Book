import 'package:flutter/material.dart';
import '../../uivalue.dart';
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
            width: UIValue.borderWidthNormal,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(UIValue.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CalendarWidget(
              initialSelectedDate: selectedDate,
              refreshTrigger: refreshTrigger,
              uiType: CalendarUIType.window,
              onDateSelected: (date) {
                if (rightPanelIndex == 1) {
                  onDateSelected(date);
                } else {
                  onDateSelected(date);
                }
              },
            ),
            SizedBox(height: UIValue.smallGap),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
