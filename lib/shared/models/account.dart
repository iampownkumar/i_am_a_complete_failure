// File: lib/shared/models/account.dart
// Purpose: Account model for managing bank accounts, savings, and other financial accounts

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/enums/app_enums.dart';

class Account extends Equatable {
  final String id;
  final String name;
  final AccountType type;
  final String? bankName;
  final String? accountNumber;
  final String? routingNumber;
  final String? ifscCode;
  final double balance;
  final Currency currency;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    this.bankName,
    this.accountNumber,
    this.routingNumber,
    this.ifscCode,
    required this.balance,
    this.currency = Currency.inr,
    this.description,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Account.create({
    required String name,
    required AccountType type,
    String? bankName,
    String? accountNumber,
    String? routingNumber,
    String? ifscCode,
    double balance = 0.0,
    Currency currency = Currency.inr,
    String? description,
    bool isActive = true,
  }) {
    final now = DateTime.now();
    return Account(
      id: const Uuid().v4(),
      name: name,
      type: type,
      bankName: bankName,
      accountNumber: accountNumber,
      routingNumber: routingNumber,
      ifscCode: ifscCode,
      balance: balance,
      currency: currency,
      description: description,
      isActive: isActive,
      createdAt: now,
      updatedAt: now,
    );
  }

  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    String? bankName,
    String? accountNumber,
    String? routingNumber,
    String? ifscCode,
    double? balance,
    Currency? currency,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      routingNumber: routingNumber ?? this.routingNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'routingNumber': routingNumber,
      'ifscCode': ifscCode,
      'balance': balance,
      'currency': currency.name,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      name: json['name'] as String,
      type: AccountType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AccountType.savings,
      ),
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      routingNumber: json['routingNumber'] as String?,
      ifscCode: json['ifscCode'] as String?,
      balance: (json['balance'] as num).toDouble(),
      currency: Currency.values.firstWhere(
        (e) => e.name == json['currency'],
        orElse: () => Currency.inr,
      ),
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        bankName,
        accountNumber,
        routingNumber,
        ifscCode,
        balance,
        currency,
        description,
        isActive,
        createdAt,
        updatedAt,
      ];
}
