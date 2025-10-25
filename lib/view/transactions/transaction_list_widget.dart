import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../services/transaction_service.dart';
import '../../models/transaction_model.dart';

class TransactionListWidget extends StatefulWidget {
  final DateTime selectedDate;
  final bool showDailyOnly;

  const TransactionListWidget({
    super.key,
    required this.selectedDate,
    this.showDailyOnly = false,
  });

  @override
  State<TransactionListWidget> createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
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
  void didUpdateWidget(TransactionListWidget oldWidget) {
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

    // 메인 스레드에서 스트림을 처리하도록 수정
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
            const SizedBox(height: 16),
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
            Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              widget.showDailyOnly ? '오늘 거래 내역이 없습니다' : '이번 달 거래 내역이 없습니다',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return _buildTransactionTile(context, transaction);
      },
    );
  }

  Widget _buildTransactionTile(
    BuildContext context,
    TransactionModel transaction,
  ) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.blue : Colors.red;
    final icon = isIncome ? Icons.add_circle : Icons.remove_circle;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                transaction.category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}₩${NumberFormat('#,###').format(transaction.amount)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(transaction.description),
            ],
            const SizedBox(height: 4),
            Text(
              DateFormat('MM월 dd일').format(transaction.date),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        onTap: () => _showTransactionDetails(context, transaction),
        onLongPress: () => _showDeleteConfirmation(context, transaction),
      ),
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    TransactionModel transaction,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(transaction.category),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(
                '구분',
                transaction.type == TransactionType.income ? '수입' : '지출',
              ),
              _buildDetailRow(
                '금액',
                '₩${NumberFormat('#,###').format(transaction.amount)}',
              ),
              _buildDetailRow('카테고리', transaction.category),
              if (transaction.description.isNotEmpty)
                _buildDetailRow('설명', transaction.description),
              _buildDetailRow(
                '날짜',
                DateFormat('yyyy년 MM월 dd일').format(transaction.date),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    TransactionModel transaction,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('거래 내역 삭제'),
          content: Text('${transaction.category} 거래 내역을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && transaction.id != null) {
                    await TransactionService.deleteTransaction(
                      userId: user.uid,
                      transactionId: transaction.id!,
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('거래 내역이 삭제되었습니다')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')),
                    );
                  }
                }
              },
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
