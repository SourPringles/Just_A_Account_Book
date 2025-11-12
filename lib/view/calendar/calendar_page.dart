import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../services/transaction_service.dart';
import '../../models/transaction_model.dart';
import 'widgets/calendar_widget_grid.dart';

// UI 타입을 나타내는 enum
enum CalendarUIType { mobile, window }

class CalendarPage extends StatefulWidget {
  final DateTime? initialSelectedDate;
  final Function(DateTime)? onDateSelected;
  final int? refreshTrigger;
  final CalendarUIType? uiType;

  const CalendarPage({
    super.key,
    this.initialSelectedDate,
    this.onDateSelected,
    this.refreshTrigger,
    this.uiType,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _showWeeklySummary = false;
  Timer? _summaryTimer;

  // 날짜별 거래 데이터 캐시
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
  void didUpdateWidget(CalendarPage oldWidget) {
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

  // 주간 합계 계산
  double _getWeeklyTotal() {
    if (_calendarFormat != CalendarFormat.week) return 0;

    final baseDay = _focusedDay;
    final startOfWeek = baseDay.subtract(Duration(days: baseDay.weekday % 7));
    double total = 0;

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final dailyTotals = _dailyTotals[dateKey] ?? {'income': 0, 'expense': 0};
      final income = dailyTotals['income'] ?? 0;
      final expense = dailyTotals['expense'] ?? 0;
      total += income - expense;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: CalendarGridWidget(
        selectedDay: _selectedDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        showWeeklySummary: _showWeeklySummary,
        dailyTotals: _dailyTotals,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          widget.onDateSelected?.call(selectedDay);
        },
        onFormatChanged: (format) {
          if (mounted) {
            // When switching formats, update the calendar format immediately.
            setState(() {
              _calendarFormat = format;
              // hide the weekly summary initially when starting transition away/from month
              if (format != CalendarFormat.week) _showWeeklySummary = false;
            });

            // If switched to week view, delay showing the summary until the
            // collapse animation finishes to avoid RenderFlex overflow.
            _summaryTimer?.cancel();
            if (format == CalendarFormat.week) {
              _summaryTimer = Timer(const Duration(milliseconds: 350), () {
                if (mounted) {
                  setState(() {
                    _showWeeklySummary = true;
                  });
                }
              });
            }
          }
        },
        onPageChanged: (focusedDay) {
          if (mounted) {
            setState(() {
              _focusedDay = focusedDay;
            });
            _loadMonthlyData();
            widget.onDateSelected?.call(focusedDay);
          }
        },
        weeklyTotal: _getWeeklyTotal(),
      ),
    );
  }

  @override
  void dispose() {
    _summaryTimer?.cancel();
    super.dispose();
  }
}
