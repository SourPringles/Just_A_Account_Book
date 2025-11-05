import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_colors.dart';
import '../../uivalue/ui_text.dart';
import 'calendar_widget_day_cell.dart';
import 'calendar_widget_summary.dart';

/// TableCalendar를 래핑한 그리드 위젯
class CalendarGridWidget extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final Map<String, Map<String, double>> dailyTotals;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final Function(CalendarFormat format) onFormatChanged;
  final Function(DateTime focusedDay) onPageChanged;
  final double weeklyTotal;

  const CalendarGridWidget({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    required this.calendarFormat,
    required this.dailyTotals,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.weeklyTotal,
  });

  Map<String, double> _getDailyTotals(DateTime date) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    return dailyTotals[dateKey] ?? {'income': 0, 'expense': 0};
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableCalendar(
          locale: locale.toString(),
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          calendarFormat: calendarFormat,
          availableCalendarFormats: {
            CalendarFormat.month: l10n.calendarMonthly,
            CalendarFormat.week: l10n.calendarWeekly,
          },
          availableGestures: AvailableGestures.none,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          onDaySelected: onDaySelected,
          onFormatChanged: onFormatChanged,
          onPageChanged: onPageChanged,
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            cellMargin: EdgeInsets.all(UILayout.tinyGap / 2),
            cellPadding: EdgeInsets.all(UILayout.tinyGap),
            defaultTextStyle: TextStyle(fontSize: UIText.calendarDayNumber),
            weekendTextStyle: TextStyle(
              fontSize: UIText.calendarDayNumber,
              color: UIColors.sundayTextColor(context),
            ),
            rowDecoration: const BoxDecoration(),
          ),
          rowHeight: UIText.calendarRowHeight,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontSize: UIText.calendarDayOfWeek,
              fontWeight: FontWeight.w600,
              color: UIColors.textPrimaryColor(context),
            ),
            weekendStyle: TextStyle(
              fontSize: UIText.calendarDayOfWeek,
              fontWeight: FontWeight.w600,
              color: UIColors.sundayTextColor(context),
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonShowsNext: false,
            titleTextStyle: TextStyle(
              fontSize: UIText.calendarHeader,
              fontWeight: FontWeight.w600,
              color: UIColors.textPrimaryColor(context),
            ),
            formatButtonDecoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            formatButtonTextStyle: TextStyle(
              color: UIColors.whiteColor,
              fontSize: UIText.calendarHeader - 2,
            ),
            leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.blue),
            rightChevronIcon: const Icon(
              Icons.chevron_right,
              color: Colors.blue,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, _) {
              return CalendarDayCellWidget(
                date: date,
                dailyTotals: _getDailyTotals(date),
              );
            },
            selectedBuilder: (context, date, _) {
              return CalendarDayCellWidget(
                date: date,
                dailyTotals: _getDailyTotals(date),
                isSelected: true,
              );
            },
            todayBuilder: (context, date, _) {
              return CalendarDayCellWidget(
                date: date,
                dailyTotals: _getDailyTotals(date),
                isToday: true,
              );
            },
            dowBuilder: (context, day) {
              final l10n = AppLocalizations.of(context)!;
              String text;
              Color textColor = UIColors.textPrimaryColor(context);

              switch (day.weekday) {
                case DateTime.sunday:
                  text = l10n.sunday;
                  textColor = UIColors.sundayTextColor(context);
                  break;
                case DateTime.monday:
                  text = l10n.monday;
                  break;
                case DateTime.tuesday:
                  text = l10n.tuesday;
                  break;
                case DateTime.wednesday:
                  text = l10n.wednesday;
                  break;
                case DateTime.thursday:
                  text = l10n.thursday;
                  break;
                case DateTime.friday:
                  text = l10n.friday;
                  break;
                case DateTime.saturday:
                  text = l10n.saturday;
                  textColor = UIColors.saturdayTextColor(context);
                  break;
                default:
                  text = '';
              }

              return Container(
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: UIText.calendarDayOfWeek,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
        SizedBox(height: UILayout.largeGap),
        if (calendarFormat == CalendarFormat.week)
          CalendarSummaryWidget(
            val: weeklyTotal.toInt(),
            label: l10n.weeklyTotal,
            color: UIColors.textPrimaryColor(context),
            fontSize: UIText.calendarSumFontSize,
          ),
      ],
    );
  }
}
