import 'package:flutter/material.dart';
import '../../uivalue/ui_layout.dart';
import '../../transactions/transactions_page.dart';
import '../../transactions/widgets/transaction_widget_monthly_summary.dart';
import 'home_widget_right_panel_tabs.dart';
import 'home_widget_transaction_header.dart';
import '../../transactions/add_transaction_dialog.dart';

class RightPanelWidget extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback onTransactionAdded;
  final int initialIndex;
  final ValueChanged<int>? onIndexChanged;

  const RightPanelWidget({
    super.key,
    required this.selectedDate,
    required this.onTransactionAdded,
    this.initialIndex = 0,
    this.onIndexChanged,
  });

  @override
  State<RightPanelWidget> createState() => _RightPanelWidgetState();
}

class _RightPanelWidgetState extends State<RightPanelWidget> {
  late int _panelIndex; // 0: 거래내역, 1: 요약
  late DateTime _lastMonth; // 마지막으로 렌더링된 월 추적
  Widget? _cachedSummaryContent; // 요약 탭 콘텐츠 캐시
  String? _cachedMonthKey; // 캐시된 월 키

  @override
  void initState() {
    super.initState();
    _panelIndex = widget.initialIndex;
    _lastMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  @override
  void didUpdateWidget(RightPanelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 요약 탭(index 1)일 때는 월이 변경된 경우만 업데이트
    if (_panelIndex == 1) {
      final newMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
      final oldMonth = DateTime(oldWidget.selectedDate.year, oldWidget.selectedDate.month);
      
      if (newMonth != oldMonth) {
        _lastMonth = newMonth;
        _cachedSummaryContent = null; // 캐시 무효화
        _cachedMonthKey = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RightPanelTabsWidget(
          currentIndex: _panelIndex,
          onTabSelected: (i) => setState(() {
            _panelIndex = i;
            // 요약 탭으로 전환 시 현재 선택된 날짜의 월로 업데이트
            if (i == 1) {
              final newMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
              if (_lastMonth != newMonth) {
                _lastMonth = newMonth;
                _cachedSummaryContent = null; // 캐시 무효화
                _cachedMonthKey = null;
              }
            }
            widget.onIndexChanged?.call(i);
          }),
        ),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    switch (_panelIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransactionHeaderWidget(
              selectedDate: widget.selectedDate,
              onAdd: () => _showAddTransactionDialog(context),
            ),
            Expanded(
              child: TransactionsPage(
                selectedDate: widget.selectedDate,
                showDailyOnly: true,
              ),
            ),
          ],
        );
      case 1:
        // 요약 탭은 월 단위이므로 _lastMonth를 사용하여 불필요한 리빌드 방지
        final monthKey = '${_lastMonth.year}-${_lastMonth.month}';
        
        // 캐시된 콘텐츠가 있고 월 키가 같으면 캐시 반환
        if (_cachedSummaryContent != null && _cachedMonthKey == monthKey) {
          return _cachedSummaryContent!;
        }
        
        // 새로운 요약 콘텐츠 생성 및 캐싱
        _cachedMonthKey = monthKey;
        _cachedSummaryContent = Column(
          key: ValueKey('summary_$monthKey'),
          children: [
            MonthlySummaryWidget(
              key: ValueKey('monthly_summary_$monthKey'),
              month: _lastMonth,
            ),
            SizedBox(height: UILayout.largeGap),
            Expanded(
              child: TransactionsPage(
                key: ValueKey('transaction_list_$monthKey'),
                selectedDate: _lastMonth,
                showDailyOnly: false,
              ),
            ),
          ],
        );
        
        return _cachedSummaryContent!;
      default:
        return Container();
    }
  }

  Future<void> _showAddTransactionDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AddTransactionDialog(initialDate: widget.selectedDate),
    );

    if (result == true && mounted) {
      // notify parent to refresh
      widget.onTransactionAdded();
    }
  }
}
