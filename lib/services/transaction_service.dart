import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class TransactionService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 거래 내역 추가
  static Future<String> addTransaction({
    required String userId,
    required TransactionType type,
    required double amount,
    required String category,
    required String description,
    required DateTime date,
  }) async {
    try {
      final transaction = TransactionModel(
        type: type,
        amount: amount,
        category: category,
        description: description,
        date: date,
        createdAt: DateTime.now(),
        userId: userId,
      );

      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .add(transaction.toMap());

      return docRef.id;
    } catch (e) {
      print('Error adding transaction: $e');
      throw e;
    }
  }

  // 거래 내역 수정
  static Future<void> updateTransaction({
    required String userId,
    required String transactionId,
    TransactionType? type,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      if (type != null) updates['type'] = type.toString().split('.').last;
      if (amount != null) updates['amount'] = amount;
      if (category != null) updates['category'] = category;
      if (description != null) updates['description'] = description;
      if (date != null) updates['date'] = Timestamp.fromDate(date);

      if (updates.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .doc(transactionId)
            .update(updates);
      }
    } catch (e) {
      print('Error updating transaction: $e');
      throw e;
    }
  }

  // 거래 내역 삭제
  static Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transactionId)
          .delete();
    } catch (e) {
      print('Error deleting transaction: $e');
      throw e;
    }
  }

  // 특정 월의 거래 내역 가져오기
  static Stream<List<TransactionModel>> getMonthlyTransactions({
    required String userId,
    required DateTime month,
  }) {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList(),
        );
  }

  // 특정 날짜의 거래 내역 가져오기
  static Stream<List<TransactionModel>> getDailyTransactions({
    required String userId,
    required DateTime date,
  }) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList(),
        );
  }

  // 특정 월의 거래 내역 가져오기 (Future 버전 - 캘린더용)
  static Future<List<TransactionModel>> getMonthlyTransactionsFuture({
    required String userId,
    required DateTime month,
  }) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where(
            'date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
          )
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting monthly transactions: $e');
      return [];
    }
  }

  // 특정 카테고리의 거래 내역 가져오기
  static Stream<List<TransactionModel>> getTransactionsByCategory({
    required String userId,
    required String category,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('category', isEqualTo: category);

    if (startDate != null) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }

    if (endDate != null) {
      query = query.where(
        'date',
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    return query
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList(),
        );
  }

  // 월별 수입/지출 합계 계산
  static Future<Map<String, double>> getMonthlyTotals({
    required String userId,
    required DateTime month,
  }) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where(
            'date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
          )
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .get();

      double totalIncome = 0;
      double totalExpense = 0;

      for (var doc in snapshot.docs) {
        final transaction = TransactionModel.fromFirestore(doc);
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }

      return {
        'income': totalIncome,
        'expense': totalExpense,
        'balance': totalIncome - totalExpense,
      };
    } catch (e) {
      print('Error calculating monthly totals: $e');
      return {'income': 0, 'expense': 0, 'balance': 0};
    }
  }

  // 카테고리별 지출 분석
  static Future<Map<String, double>> getCategoryExpenses({
    required String userId,
    required DateTime month,
  }) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('type', isEqualTo: 'expense')
          .where(
            'date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
          )
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .get();

      Map<String, double> categoryTotals = {};

      for (var doc in snapshot.docs) {
        final transaction = TransactionModel.fromFirestore(doc);
        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }

      return categoryTotals;
    } catch (e) {
      print('Error getting category expenses: $e');
      return {};
    }
  }
}
