import 'package:flutter/material.dart';
import '../../uivalue.dart';
import '../../transactions/transaction_list_widget.dart';
import '../../transactions/monthly_summary_widget.dart';
import 'right_panel_tabs_widget.dart';
import 'transaction_header_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _panelIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RightPanelTabsWidget(
          currentIndex: _panelIndex,
          onTabSelected: (i) => setState(() {
            _panelIndex = i;
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
              child: TransactionListWidget(
                selectedDate: widget.selectedDate,
                showDailyOnly: true,
              ),
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(UIValue.defaultPadding),
              child: MonthlySummaryWidget(month: widget.selectedDate),
            ),
            SizedBox(height: UIValue.largeGap),
            Expanded(
              child: TransactionListWidget(
                selectedDate: widget.selectedDate,
                showDailyOnly: false,
              ),
            ),
          ],
        );
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
