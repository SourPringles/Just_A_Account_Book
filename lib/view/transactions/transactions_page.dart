import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../services/transaction_service.dart';
import '../../models/transaction_model.dart';
import '../uivalue/ui_layout.dart';
import '../uivalue/ui_colors.dart';
import '../uivalue/ui_text.dart';
import 'widgets/transaction_widget_item.dart';
import 'widgets/transaction_widget_detail_dialog.dart';
import 'widgets/transaction_widget_delete_dialog.dart';
import 'add_transaction_dialog.dart';

/// 거래 내역 목록 페이지
class TransactionsPage extends StatefulWidget {
  final DateTime selectedDate;
  final bool showDailyOnly;

  const TransactionsPage({
    super.key,
    required this.selectedDate,
    this.showDailyOnly = false,
  });

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  StreamSubscription<List<TransactionModel>>? _subscription;
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void didUpdateWidget(TransactionsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.showDailyOnly != widget.showDailyOnly) {
      _loadTransactions();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _loadTransactions() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _error = '로그인이 필요합니다';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    _subscription?.cancel();

    Future.microtask(() {
      final stream = widget.showDailyOnly
          ? TransactionService.getDailyTransactions(
              userId: user.uid,
              date: widget.selectedDate,
            )
          : TransactionService.getMonthlyTransactions(
              userId: user.uid,
              month: widget.selectedDate,
            );

      _subscription = stream.listen(
        (transactions) {
          if (mounted) {
            setState(() {
              _transactions = transactions;
              _isLoading = false;
              _error = null;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _error = error.toString();
              _isLoading = false;
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('로그인이 필요합니다'));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('오류: $_error'),
            SizedBox(height: UILayout.largeGap),
            ElevatedButton(
              onPressed: _loadTransactions,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: UILayout.iconSizeXL,
              color: UIColors.dividerColor,
            ),
            SizedBox(height: UILayout.largeGap),
            Text(
              widget.showDailyOnly ? '오늘 거래 내역이 없습니다' : '이번 달 거래 내역이 없습니다',
              style: TextStyle(
                fontSize: UIText.mediumFontSize,
                color: UIColors.mutedTextColor(context),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return TransactionWidgetItem(
          transaction: transaction,
          onTap: () => _showTransactionDetails(context, transaction),
          onLongPress: () => _showDeleteConfirmation(context, transaction),
        );
      },
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    TransactionModel transaction,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TransactionWidgetDetailDialog(
          transaction: transaction,
          onEdit: () => _showEditDialog(context, transaction),
          onDelete: () => _showDeleteConfirmation(context, transaction),
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    TransactionModel transaction,
  ) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTransactionDialog(transaction: transaction);
      },
    );

    if (result == true) {
      _loadTransactions();
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    TransactionModel transaction,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TransactionWidgetDeleteDialog(
          transaction: transaction,
          onDeleted: _loadTransactions,
        );
      },
    );
  }
}
