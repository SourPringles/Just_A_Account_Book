import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../services/transaction_service.dart';
import '../../services/settings_service.dart';
import '../../models/transaction_model.dart';
import '../dialog/dialog_header_widget.dart';
import '../uivalue/ui_layout.dart';
import '../uivalue/ui_colors.dart';

class AddTransactionDialog extends StatefulWidget {
  final DateTime? initialDate;
  final TransactionModel? transaction; // 수정할 거래 (null이면 새로 추가)

  const AddTransactionDialog({
    super.key,
    this.initialDate,
    this.transaction,
  });

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = '';
  late DateTime _selectedDate;

  // 카테고리 목록 - build 메서드에서 l10n으로 초기화
  Map<TransactionType, List<String>> _categories = {};

  @override
  void initState() {
    super.initState();
    
    // 수정 모드인 경우 기존 데이터로 초기화
    if (widget.transaction != null) {
      final transaction = widget.transaction!;
      _selectedType = transaction.type;
      _selectedCategory = transaction.category;
      _selectedDate = transaction.date;
      _amountController.text = transaction.amount.toString(); // int는 자동으로 깔끔하게 표시됨
      _descriptionController.text = transaction.description;
    } else {
      // 새로 추가하는 경우
      _selectedDate = widget.initialDate ?? DateTime.now();
      // _selectedCategory는 build에서 초기화
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // 카테고리 초기화 (l10n 사용)
    if (_categories.isEmpty) {
      _categories = {
        TransactionType.income: [
          l10n.categorySalary,
          l10n.categorySideJob,
          l10n.categoryInvestment,
          l10n.categoryOtherIncome,
        ],
        TransactionType.expense: [
          l10n.categoryFood,
          l10n.categoryTransport,
          l10n.categoryShopping,
          l10n.categoryCulture,
          l10n.categoryMedical,
          l10n.categoryOtherExpense,
        ],
      };
      
      // 새 추가 모드이고 카테고리가 비어있으면 초기화
      if (widget.transaction == null && _selectedCategory.isEmpty) {
        _selectedCategory = _categories[_selectedType]!.first;
      }
    }
    
    final currencySymbol = SettingsService.instance.currencySymbol.value;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(UILayout.dialogPadding),
        constraints: BoxConstraints(
          maxWidth: UILayout.dialogMaxWidth,
          maxHeight: UILayout.dialogMaxHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialogHeaderWidget(
              title: widget.transaction != null
                  ? '${_selectedType == TransactionType.income ? l10n.income : l10n.expense} ${l10n.edit}'
                  : '${_selectedType == TransactionType.income ? l10n.income : l10n.expense} ${l10n.addTransaction}',
              onClose: () => Navigator.of(context).pop(),
            ),
            const Divider(),
            SizedBox(height: UILayout.largeGap),
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 수입/지출 선택
                      SegmentedButton<TransactionType>(
                        segments: [
                          ButtonSegment(
                            value: TransactionType.income,
                            label: Text(l10n.income),
                            icon: Icon(Icons.add_circle, color: UIColors.incomeColor),
                          ),
                          ButtonSegment(
                            value: TransactionType.expense,
                            label: Text(l10n.expense),
                            icon: Icon(Icons.remove_circle, color: UIColors.expenseColor),
                          ),
                        ],
                        selected: {_selectedType},
                        onSelectionChanged: (Set<TransactionType> selection) {
                          setState(() {
                            _selectedType = selection.first;
                            _selectedCategory =
                                _categories[_selectedType]!.first;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // 금액 입력
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: l10n.amount,
                          prefixText: '$currencySymbol ',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.validationAmount;
                          }
                          if (int.tryParse(value) == null) { // double에서 int로 변경
                            return l10n.validationInteger;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 카테고리 선택
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: l10n.category,
                          border: OutlineInputBorder(),
                        ),
                        items: _categories[_selectedType]!
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // 설명 입력
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.description,
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // 날짜 선택
                      ListTile(
                        title: Text(l10n.date),
                        subtitle: Text(
                          DateFormat('yyyy년 MM월 dd일').format(_selectedDate),
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: UILayout.largeGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                SizedBox(width: UILayout.smallGap),
                ElevatedButton(
                  onPressed: _saveTransaction,
                  child: Text(l10n.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final l10n = AppLocalizations.of(context)!;

      try {
        if (widget.transaction != null) {
          // 수정 모드
          final transactionId = widget.transaction!.id;
          if (transactionId == null) {
            throw Exception(l10n.errorTransactionIdNotFound);
          }
          
          await TransactionService.updateTransaction(
            userId: user.uid,
            transactionId: transactionId,
            type: _selectedType,
            amount: int.parse(_amountController.text), // double에서 int로 변경
            category: _selectedCategory,
            description: _descriptionController.text,
            date: _selectedDate,
          );
        } else {
          // 추가 모드
          await TransactionService.addTransaction(
            userId: user.uid,
            type: _selectedType,
            amount: int.parse(_amountController.text), // double에서 int로 변경
            category: _selectedCategory,
            description: _descriptionController.text,
            date: _selectedDate,
          );
        }

        if (mounted) {
          Navigator.of(context).pop(true); // true를 반환하여 성공을 알림
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.transaction != null
                    ? l10n.successTransactionUpdated
                    : l10n.successTransactionSaved,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${l10n.errorSaving}: $e')));
        }
      }
    }
  }
}
