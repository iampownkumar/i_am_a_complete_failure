// File: lib/shared/models/credit_card.dart
// Purpose: Credit card model for managing credit card information and balances

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/enums/app_enums.dart';

class CreditCard extends Equatable {
  final String id;
  final String name;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final CreditCardType type;
  final String? bankName;
  final double creditLimit;
  final double availableCredit;
  final double outstandingBalance;
  final double minimumPayment;
  final DateTime dueDate;
  final double apr;
  final Currency currency;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CreditCard({
    required this.id,
    required this.name,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.type,
    this.bankName,
    required this.creditLimit,
    required this.availableCredit,
    required this.outstandingBalance,
    required this.minimumPayment,
    required this.dueDate,
    required this.apr,
    this.currency = Currency.inr,
    this.description,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreditCard.create({
    required String name,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required CreditCardType type,
    String? bankName,
    required double creditLimit,
    double outstandingBalance = 0.0,
    required DateTime dueDate,
    required double apr,
    Currency currency = Currency.inr,
    String? description,
    bool isActive = true,
  }) {
    final now = DateTime.now();
    final availableCredit = creditLimit - outstandingBalance;
    final minimumPayment = (outstandingBalance * 0.05).clamp(0.0, double.infinity);
    
    return CreditCard(
      id: const Uuid().v4(),
      name: name,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
      type: type,
      bankName: bankName,
      creditLimit: creditLimit,
      availableCredit: availableCredit,
      outstandingBalance: outstandingBalance,
      minimumPayment: minimumPayment,
      dueDate: dueDate,
      apr: apr,
      currency: currency,
      description: description,
      isActive: isActive,
      createdAt: now,
      updatedAt: now,
    );
  }

  CreditCard copyWith({
    String? id,
    String? name,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    CreditCardType? type,
    String? bankName,
    double? creditLimit,
    double? availableCredit,
    double? outstandingBalance,
    double? minimumPayment,
    DateTime? dueDate,
    double? apr,
    Currency? currency,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CreditCard(
      id: id ?? this.id,
      name: name ?? this.name,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      type: type ?? this.type,
      bankName: bankName ?? this.bankName,
      creditLimit: creditLimit ?? this.creditLimit,
      availableCredit: availableCredit ?? this.availableCredit,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      minimumPayment: minimumPayment ?? this.minimumPayment,
      dueDate: dueDate ?? this.dueDate,
      apr: apr ?? this.apr,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get creditUtilizationPercentage {
    if (creditLimit == 0) return 0.0;
    return (outstandingBalance / creditLimit) * 100;
  }

  bool get isOverLimit => outstandingBalance > creditLimit;
  
  bool get isNearLimit => creditUtilizationPercentage >= 80.0;
  
  bool get isDueSoon {
    final now = DateTime.now();
    final daysUntilDue = dueDate.difference(now).inDays;
    return daysUntilDue <= 7 && daysUntilDue >= 0;
  }
  
  bool get isOverdue {
    final now = DateTime.now();
    return dueDate.isBefore(now);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'type': type.name,
      'bankName': bankName,
      'creditLimit': creditLimit,
      'availableCredit': availableCredit,
      'outstandingBalance': outstandingBalance,
      'minimumPayment': minimumPayment,
      'dueDate': dueDate.toIso8601String(),
      'apr': apr,
      'currency': currency.name,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'] as String,
      name: json['name'] as String,
      cardNumber: json['cardNumber'] as String,
      expiryDate: json['expiryDate'] as String,
      cvv: json['cvv'] as String,
      type: CreditCardType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CreditCardType.visa,
      ),
      bankName: json['bankName'] as String?,
      creditLimit: (json['creditLimit'] as num).toDouble(),
      availableCredit: (json['availableCredit'] as num).toDouble(),
      outstandingBalance: (json['outstandingBalance'] as num).toDouble(),
      minimumPayment: (json['minimumPayment'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      apr: (json['apr'] as num).toDouble(),
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
        cardNumber,
        expiryDate,
        cvv,
        type,
        bankName,
        creditLimit,
        availableCredit,
        outstandingBalance,
        minimumPayment,
        dueDate,
        apr,
        currency,
        description,
        isActive,
        createdAt,
        updatedAt,
      ];
}
