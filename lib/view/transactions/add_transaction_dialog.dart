import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../services/transaction_service.dart';
import '../../models/transaction_model.dart';
import '../dialog/dialog_header_widget.dart';
import '../uivalue/ui_layout.dart';

class AddTransactionDialog extends StatefulWidget {
  final DateTime? initialDate;

  const AddTransactionDialog({super.key, this.initialDate});

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

  // 카테고리 목록
  final Map<TransactionType, List<String>> _categories = {
    TransactionType.income: ['급여', '부업', '투자수익', '기타수입'],
    TransactionType.expense: ['식비', '교통비', '쇼핑', '문화생활', '의료비', '기타지출'],
  };

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedCategory = _categories[_selectedType]!.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              title:
                  '${_selectedType == TransactionType.income ? '수입' : '지출'} 추가',
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
                        segments: const [
                          ButtonSegment(
                            value: TransactionType.income,
                            label: Text('수입'),
                            icon: Icon(Icons.add_circle, color: Colors.green),
                          ),
                          ButtonSegment(
                            value: TransactionType.expense,
                            label: Text('지출'),
                            icon: Icon(Icons.remove_circle, color: Colors.red),
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
                        decoration: const InputDecoration(
                          labelText: '금액',
                          prefixText: '₩ ',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '금액을 입력하세요';
                          }
                          if (double.tryParse(value) == null) {
                            return '올바른 숫자를 입력하세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 카테고리 선택
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: '카테고리',
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
                        decoration: const InputDecoration(
                          labelText: '설명 (선택사항)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // 날짜 선택
                      ListTile(
                        title: const Text('날짜'),
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
                  child: const Text('취소'),
                ),
                SizedBox(width: UILayout.smallGap),
                ElevatedButton(
                  onPressed: _saveTransaction,
                  child: const Text('저장'),
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

      try {
        await TransactionService.addTransaction(
          userId: user.uid,
          type: _selectedType,
          amount: double.parse(_amountController.text),
          category: _selectedCategory,
          description: _descriptionController.text,
          date: _selectedDate,
        );

        if (mounted) {
          Navigator.of(context).pop(true); // true를 반환하여 성공을 알림
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('거래 내역이 저장되었습니다')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')));
        }
      }
    }
  }
}
