// File: lib/shared/models/transaction.dart
// Purpose: Transaction model defining the structure for all financial transactions

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/enums/app_enums.dart';

class Transaction extends Equatable {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final String category;
  final String? subCategory;
  final DateTime date;
  final String? accountId;
  final String? creditCardId;
  final String? transferToAccountId;
  final List<String> tags;
  final String? notes;
  final Currency currency;
  final TransactionStatus status;
  final RecurringType recurringType;
  final String? recurringId;
  final String? smsId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.category,
    this.subCategory,
    required this.date,
    this.accountId,
    this.creditCardId,
    this.transferToAccountId,
    this.tags = const [],
    this.notes,
    this.currency = Currency.inr,
    this.status = TransactionStatus.completed,
    this.recurringType = RecurringType.none,
    this.recurringId,
    this.smsId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.create({
    required TransactionType type,
    required double amount,
    required String description,
    required String category,
    String? subCategory,
    required DateTime date,
    String? accountId,
    String? creditCardId,
    String? transferToAccountId,
    List<String> tags = const [],
    String? notes,
    Currency currency = Currency.inr,
    TransactionStatus status = TransactionStatus.completed,
    RecurringType recurringType = RecurringType.none,
    String? recurringId,
    String? smsId,
  }) {
    final now = DateTime.now();
    return Transaction(
      id: const Uuid().v4(),
      type: type,
      amount: amount,
      description: description,
      category: category,
      subCategory: subCategory,
      date: date,
      accountId: accountId,
      creditCardId: creditCardId,
      transferToAccountId: transferToAccountId,
      tags: tags,
      notes: notes,
      currency: currency,
      status: status,
      recurringType: recurringType,
      recurringId: recurringId,
      smsId: smsId,
      createdAt: now,
      updatedAt: now,
    );
  }

  Transaction copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    String? description,
    String? category,
    String? subCategory,
    DateTime? date,
    String? accountId,
    String? creditCardId,
    String? transferToAccountId,
    List<String>? tags,
    String? notes,
    Currency? currency,
    TransactionStatus? status,
    RecurringType? recurringType,
    String? recurringId,
    String? smsId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      date: date ?? this.date,
      accountId: accountId ?? this.accountId,
      creditCardId: creditCardId ?? this.creditCardId,
      transferToAccountId: transferToAccountId ?? this.transferToAccountId,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      recurringType: recurringType ?? this.recurringType,
      recurringId: recurringId ?? this.recurringId,
      smsId: smsId ?? this.smsId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'description': description,
      'category': category,
      'subCategory': subCategory,
      'date': date.toIso8601String(),
      'accountId': accountId,
      'creditCardId': creditCardId,
      'transferToAccountId': transferToAccountId,
      'tags': tags,
      'notes': notes,
      'currency': currency.name,
      'status': status.name,
      'recurringType': recurringType.name,
      'recurringId': recurringId,
      'smsId': smsId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String?,
      date: DateTime.parse(json['date'] as String),
      accountId: json['accountId'] as String?,
      creditCardId: json['creditCardId'] as String?,
      transferToAccountId: json['transferToAccountId'] as String?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      notes: json['notes'] as String?,
      currency: Currency.values.firstWhere(
        (e) => e.name == json['currency'],
        orElse: () => Currency.inr,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.completed,
      ),
      recurringType: RecurringType.values.firstWhere(
        (e) => e.name == json['recurringType'],
        orElse: () => RecurringType.none,
      ),
      recurringId: json['recurringId'] as String?,
      smsId: json['smsId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        description,
        category,
        subCategory,
        date,
        accountId,
        creditCardId,
        transferToAccountId,
        tags,
        notes,
        currency,
        status,
        recurringType,
        recurringId,
        smsId,
        createdAt,
        updatedAt,
      ];
}
