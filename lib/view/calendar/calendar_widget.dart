import 'package:just_a_account_book/view/calendar/sum_widget.dart';
import 'package:flutter/material.dart';
import '../uivalue.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../services/transaction_service.dart';
import '../../models/transaction_model.dart';

// UI 타입을 나타내는 enum
enum CalendarUIType { mobile, window }

// 캘린더 텍스트 스타일 클래스
class CalendarTextStyles {
  final double dayNumberSize;
  final double amountSize;
  final double headerSize;
  final double dayOfWeekSize;
  final double rowHeight;

  const CalendarTextStyles({
    required this.dayNumberSize,
    required this.amountSize,
    required this.headerSize,
    required this.dayOfWeekSize,
    required this.rowHeight,
  });
}

class CalendarWidget extends StatefulWidget {
  final DateTime? initialSelectedDate;
  final Function(DateTime)? onDateSelected;
  final int? refreshTrigger; // 새로고침을 위한 트리거
  final CalendarUIType? uiType; // UI 타입 (모바일/윈도우/개발용)

  const CalendarWidget({
    super.key,
    this.initialSelectedDate,
    this.onDateSelected,
    this.refreshTrigger,
    this.uiType, // null이면 자동으로 감지
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // 날짜별 거래 데이터 캐시 (날짜 -> {income: double, expense: double})
  Map<String, Map<String, double>> _dailyTotals = {};
  String _currentMonthKey = '';

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialSelectedDate ?? DateTime.now();
    _focusedDay = widget.initialSelectedDate ?? DateTime.now();
    _loadMonthlyData();
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // refreshTrigger가 변경되면 데이터 리로드
    if (widget.refreshTrigger != oldWidget.refreshTrigger) {
      _loadMonthlyData(forceReload: true);
    }
  }

  // 현재 표시 중인 달의 거래 데이터를 로드
  Future<void> _loadMonthlyData({bool forceReload = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 현재 월과 같으면 다시 로드하지 않음 (강제 리로드가 아닌 경우)
    final monthKey = DateFormat('yyyy-MM').format(_focusedDay);
    if (!forceReload &&
        _currentMonthKey == monthKey &&
        _dailyTotals.isNotEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _currentMonthKey = monthKey;
      });
    }

    try {
      final transactions =
          await TransactionService.getMonthlyTransactionsFuture(
            userId: user.uid,
            month: _focusedDay,
          );

      final Map<String, Map<String, double>> newTotals = {};

      for (final transaction in transactions) {
        final dateKey = DateFormat('yyyy-MM-dd').format(transaction.date);

        if (!newTotals.containsKey(dateKey)) {
          newTotals[dateKey] = {'income': 0, 'expense': 0};
        }

        if (transaction.type == TransactionType.income) {
          newTotals[dateKey]!['income'] =
              (newTotals[dateKey]!['income'] ?? 0) + transaction.amount;
        } else {
          newTotals[dateKey]!['expense'] =
              (newTotals[dateKey]!['expense'] ?? 0) + transaction.amount;
        }
      }

      if (mounted) {
        setState(() {
          _dailyTotals = newTotals;
        });
      }
    } catch (e) {
      debugPrint('Error loading monthly data: $e');
    }
  }

  // 특정 날짜의 수입/지출 합계 가져오기
  Map<String, double> _getDailyTotals(DateTime date) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    return _dailyTotals[dateKey] ?? {'income': 0, 'expense': 0};
  }

  // 외부에서 데이터를 강제로 리로드할 수 있는 메서드
  void refreshData() {
    _loadMonthlyData(forceReload: true);
  }

  // 월간 수입 합계 계산
  // 월간 수입/지출 합계 계산 함수들: 현재 사용되지 않아 주석 처리했습니다.
  // double _getMonthlyIncome() {
  //   double total = 0;
  //   for (final dailyTotals in _dailyTotals.values) {
  //     total += dailyTotals['income'] ?? 0;
  //   }
  //   return total;
  // }
  //
  // // 월간 지출 합계 계산
  // double _getMonthlyExpense() {
  //   double total = 0;
  //   for (final dailyTotals in _dailyTotals.values) {
  //     total += dailyTotals['expense'] ?? 0;
  //   }
  //   return total;
  // }

  // 월간 순액 계산 (수입 - 지출)
  // 월간 순액 계산 함수는 현재 사용되지 않아 주석 처리했습니다.
  // double _getMonthlyBalance() {
  //   return _getMonthlyIncome() - _getMonthlyExpense();
  // }

  // 주간 합계 계산 (선택된 주의 합계)
  double _getWeeklyTotal() {
    if (_calendarFormat != CalendarFormat.week) return 0;

    // 페이지 전환으로 주가 바뀌면 focusedDay를 기준으로 합계를 계산하도록 변경
    final baseDay = _focusedDay;
    final startOfWeek = baseDay.subtract(Duration(days: baseDay.weekday % 7));
    double total = 0;

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dailyTotals = _getDailyTotals(date);
      final income = dailyTotals['income'] ?? 0;
      final expense = dailyTotals['expense'] ?? 0;
      total += income - expense; // 순액 (수입 - 지출)
    }

    return total;
  }

  // UI 타입에 따른 텍스트 스타일 설정
  CalendarTextStyles _getTextStyles() {
    final uiType = widget.uiType ?? CalendarUIType.mobile; // null이면 모바일로 기본 설정

    switch (uiType) {
      case CalendarUIType.window:
        return CalendarTextStyles(
          dayNumberSize: 16.0,
          amountSize: 12.0,
          headerSize: 16.0,
          dayOfWeekSize: 14.0,
          rowHeight: 75.0,
        );
      case CalendarUIType.mobile:
        return CalendarTextStyles(
          dayNumberSize: 14.0,
          amountSize: 10.0,
          headerSize: 14.0,
          dayOfWeekSize: 14.0,
          rowHeight: 80.0,
        );
    }
  }

  // 기본 날짜 셀 디자인 생성 함수
  Widget _buildDefaultCell(BuildContext context, DateTime date) {
    final textStyles = _getTextStyles();

    // 다크 모드는 UIValue.textPrimaryColor에서 처리

    // 요일에 따른 날짜 색상 설정 (주말은 예외)
    Color dateTextColor = UIValue.textPrimaryColor(context);
    if (date.weekday == DateTime.sunday) {
      dateTextColor = UIValue.sundayTextColor(context);
    } else if (date.weekday == DateTime.saturday) {
      dateTextColor = UIValue.saturdayTextColor(context);
    }

    // 해당 날짜의 거래 데이터 가져오기
    final dailyTotals = _getDailyTotals(date);
    final income = dailyTotals['income'] ?? 0;
    final expense = dailyTotals['expense'] ?? 0;

    // 금액을 간단한 형태로 포맷 (천원 단위)
    String formatAmount(double amount) {
      if (amount == 0) return '';
      if (amount >= 10000) {
        return '${NumberFormat('#.#').format(amount / 10000)}만';
      } else if (amount >= 1000) {
        return '${(amount / 1000).toInt()}천';
      } else {
        return amount.toInt().toString();
      }
    }

    return Container(
      margin: EdgeInsets.all(UIValue.tinyGap),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: UIValue.borderWidthThin,
        ),
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
                fontSize: textStyles.dayNumberSize,
                fontWeight: FontWeight.w500,
                color: dateTextColor,
              ),
            ),
          ),
          // 거래 금액 영역 (수입/지출)
          Expanded(
            child: Container(
              margin: EdgeInsets.all(UIValue.tinyGap / 2),
              padding: EdgeInsets.all(UIValue.tinyGap),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 수입 (파란색)
                  Text(
                    income > 0 ? '+${formatAmount(income)}' : '',
                    style: TextStyle(
                      fontSize: textStyles.amountSize,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // 지출 (빨간색)
                  Text(
                    expense > 0 ? '-${formatAmount(expense)}' : '',
                    style: TextStyle(
                      fontSize: textStyles.amountSize,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
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
    final textStyles = _getTextStyles();

    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TableCalendar이 자신의 높이(rowHeight * rows + header 등)를 사용하도록 그대로 배치
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
            availableGestures: AvailableGestures.none,
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
                // 월이 변경되면 새로운 거래 데이터 로드
                _loadMonthlyData();
              }
            },
            calendarStyle: CalendarStyle(
              // 요일 헤더 스타일
              outsideDaysVisible: false,
              // 셀 크기 조정 - 높이를 증가시켜 텍스트 공간 확보
              cellMargin: EdgeInsets.all(UIValue.tinyGap / 2),
              cellPadding: EdgeInsets.all(UIValue.tinyGap),
              // 기본 텍스트 스타일
              defaultTextStyle: TextStyle(fontSize: textStyles.dayNumberSize),
              weekendTextStyle: TextStyle(
                fontSize: textStyles.dayNumberSize,
                color: UIValue.sundayTextColor(context),
              ),
              // 셀의 최소 높이 설정
              rowDecoration: const BoxDecoration(),
            ),
            rowHeight: textStyles.rowHeight, // UI 타입에 따른 행 높이
            daysOfWeekStyle: DaysOfWeekStyle(
              // 요일 헤더의 높이와 스타일 조정
              weekdayStyle: TextStyle(
                fontSize: textStyles.dayOfWeekSize,
                fontWeight: FontWeight.w600,
                color: UIValue.textPrimaryColor(context),
              ),
              weekendStyle: TextStyle(
                fontSize: textStyles.dayOfWeekSize,
                fontWeight: FontWeight.w600,
                color: UIValue.sundayTextColor(context),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              formatButtonTextStyle: TextStyle(
                color: UIValue.onPrimaryColor(context),
                fontSize: textStyles.headerSize - 2,
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: Colors.blue,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: Colors.blue,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              // 기본 날짜 셀 빌더
              defaultBuilder: (context, date, _) {
                return _buildDefaultCell(context, date);
              },
              selectedBuilder: (context, date, _) {
                return Stack(
                  children: [
                    // 기본 디자인 재사용
                    _buildDefaultCell(context, date),
                    // 선택 테두리 오버레이
                    Positioned.fill(
                      child: Container(
                        margin: EdgeInsets.all(UIValue.tinyGap / 2),
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
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
                    _buildDefaultCell(context, date),
                    // 오늘 날짜 테두리 오버레이 (주황색)
                    Positioned.fill(
                      child: Container(
                        margin: EdgeInsets.all(UIValue.tinyGap / 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orange,
                            width: UIValue.borderWidthNormal,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                );
              },
              dowBuilder: (context, day) {
                String text;
                Color textColor = UIValue.textPrimaryColor(context);

                switch (day.weekday) {
                  case DateTime.sunday:
                    text = '일';
                    textColor = UIValue.sundayTextColor(context);
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
                    textColor = UIValue.saturdayTextColor(context);
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
                      fontSize: textStyles.dayOfWeekSize,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: UIValue.largeGap),
          if (_calendarFormat == CalendarFormat.week)
            CommonSumWidget(
              val: _getWeeklyTotal().toInt(),
              label: '주간 합계',
              color: UIValue.textPrimaryColor(context),
              fontSize:
                  (widget.uiType ?? CalendarUIType.mobile) ==
                      CalendarUIType.window
                  ? 22.0
                  : 20.0,
            ),
        ],
      ),
    );
  }
}
