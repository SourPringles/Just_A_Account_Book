import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String? id;
  final TransactionType type;
  final int amount; // double에서 int로 변경
  final String category;
  final String description;
  final DateTime date;
  final DateTime createdAt;
  final String userId;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.createdAt,
    required this.userId,
  });

  // Firestore에서 데이터를 가져올 때 사용
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
      ),
      amount: (data['amount'] as num).toInt(), // toDouble에서 toInt로 변경
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  // Firestore에 저장할 때 사용
  Map<String, dynamic> toMap() {
    return {
      'type': type.toString().split('.').last,
      'amount': amount,
      'category': category,
      'description': description,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
    };
  }

  // 복사본 생성 (수정 시 사용)
  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    int? amount, // double에서 int로 변경
    String? category,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    String? userId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}
