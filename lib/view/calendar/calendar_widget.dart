import 'package:financial_manage_app_project/view/calendar/sum_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// TEST VALUE
int monthIncome = 00000;
int monthExpense = 00000;
int weeklyTotal = 00000;
int monthlyTotal = 00000;

class CalendarWidget extends StatefulWidget {
  final DateTime? initialSelectedDate;
  final Function(DateTime)? onDateSelected;

  const CalendarWidget({
    super.key,
    this.initialSelectedDate,
    this.onDateSelected,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialSelectedDate ?? DateTime.now();
    _focusedDay = widget.initialSelectedDate ?? DateTime.now();
  }

  // 기본 날짜 셀 디자인 생성 함수
  Widget _buildDefaultCell(DateTime date) {
    // 요일에 따른 날짜 색상 설정
    Color dateTextColor = Colors.black;
    if (date.weekday == DateTime.sunday) {
      dateTextColor = Colors.red;
    } else if (date.weekday == DateTime.saturday) {
      dateTextColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 날짜 영역
          Container(
            height: 20,
            alignment: Alignment.topLeft,
            child: Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: dateTextColor,
              ),
            ),
          ),
          // 텍스트 영역 (두 줄)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(2.0),
              padding: const EdgeInsets.all(4.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+00000',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '-00000',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: 'ko_KR',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          availableCalendarFormats: const {
            CalendarFormat.month: '월간',
            CalendarFormat.week: '주간',
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
            // 선택된 날짜를 부모 위젯에 알림
            widget.onDateSelected?.call(selectedDay);
          },
          onFormatChanged: (format) {
            if (mounted) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            if (mounted) {
              setState(() {
                _focusedDay = focusedDay;
              });
            }
          },
          calendarStyle: const CalendarStyle(
            // 요일 헤더 스타일
            outsideDaysVisible: false,
            // 셀 크기 조정 - 높이를 증가시켜 텍스트 공간 확보
            cellMargin: EdgeInsets.all(2.0),
            cellPadding: EdgeInsets.all(4.0),
            // 기본 텍스트 스타일
            defaultTextStyle: TextStyle(fontSize: 14),
            weekendTextStyle: TextStyle(fontSize: 14, color: Colors.red),
            // 셀의 최소 높이 설정
            rowDecoration: BoxDecoration(),
          ),
          rowHeight: 80.0, // 각 행의 높이를 80px로 증가
          daysOfWeekStyle: const DaysOfWeekStyle(
            // 요일 헤더의 높이와 스타일 조정
            weekdayStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            weekendStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            formatButtonTextStyle: TextStyle(color: Colors.white, fontSize: 12),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue),
          ),
          calendarBuilders: CalendarBuilders(
            // 기본 날짜 셀 빌더
            defaultBuilder: (context, date, _) {
              return _buildDefaultCell(date);
            },
            selectedBuilder: (context, date, _) {
              return Stack(
                children: [
                  // 기본 디자인 재사용
                  _buildDefaultCell(date),
                  // 선택 테두리 오버레이
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            todayBuilder: (context, date, _) {
              return Stack(
                children: [
                  // 기본 디자인 재사용 (볼드체 적용)
                  _buildDefaultCell(date),
                  // 오늘 날짜 테두리 오버레이 (주황색)
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              );
            },
            dowBuilder: (context, day) {
              String text;
              Color textColor = Colors.black;

              switch (day.weekday) {
                case DateTime.sunday:
                  text = '일';
                  textColor = Colors.red;
                  break;
                case DateTime.monday:
                  text = '월';
                  break;
                case DateTime.tuesday:
                  text = '화';
                  break;
                case DateTime.wednesday:
                  text = '수';
                  break;
                case DateTime.thursday:
                  text = '목';
                  break;
                case DateTime.friday:
                  text = '금';
                  break;
                case DateTime.saturday:
                  text = '토';
                  textColor = Colors.blue;
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        if (_calendarFormat == CalendarFormat.week)
          CommonSumWidget(
            val: weeklyTotal,
            label: '주간 합계',
            color: Colors.black,
          ),

        const SizedBox(height: 20),
        SumWidget(
          currentMonth: _focusedDay.month,
          monthIncome: monthIncome,
          monthExpense: monthExpense,
          weeklyTotal: weeklyTotal,
          monthlyTotal: monthlyTotal,
        ),
      ],
    );
  }
}
