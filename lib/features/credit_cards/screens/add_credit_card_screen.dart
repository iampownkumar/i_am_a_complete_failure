// File: lib/features/credit_cards/screens/add_credit_card_screen.dart
// Purpose: Add new credit card screen

import 'package:flutter/material.dart';
import '../../../core/constants/strings/app_strings.dart';
import '../../../core/constants/enums/app_enums.dart';
import '../../../core/constants/colors/app_colors.dart';
import '../../../shared/models/credit_card.dart';

class AddCreditCardScreen extends StatefulWidget {
  const AddCreditCardScreen({super.key});

  @override
  State<AddCreditCardScreen> createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final _cvvController = TextEditingController();
  final _limitController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  
  CreditCardType _selectedCardType = CreditCardType.visa;
  Currency _selectedCurrency = Currency.inr;
  bool _isDefault = false;

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _cvvController.dispose();
    _limitController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Credit Card'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveCreditCard,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Type Selection
              _buildCardTypeSection(),
              
              const SizedBox(height: 24),
              
              // Basic Information
              _buildBasicInfoSection(),
              
              const SizedBox(height: 24),
              
              // Card Details
              _buildCardDetailsSection(),
              
              const SizedBox(height: 24),
              
              // Limit Information
              _buildLimitSection(),
              
              const SizedBox(height: 24),
              
              // Additional Options
              _buildAdditionalOptions(),
              
              const SizedBox(height: 32),
              
              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: CreditCardType.values.map((type) {
            final isSelected = _selectedCardType == type;
            return GestureDetector(
              onTap: () => setState(() => _selectedCardType = type),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getCardTypeIcon(type),
                      color: isSelected ? Colors.white : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getCardTypeLabel(type),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardNameController,
          decoration: const InputDecoration(
            labelText: 'Card Name',
            hintText: 'e.g., My HDFC Visa Card',
            prefixIcon: Icon(Icons.credit_card),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardHolderNameController,
          decoration: const InputDecoration(
            labelText: 'Card Holder Name',
            hintText: 'e.g., John Doe',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card holder name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCardDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardNumberController,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            hintText: '1234 5678 9012 3456',
            prefixIcon: Icon(Icons.credit_card),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card number';
            }
            if (value.replaceAll(' ', '').length < 16) {
              return 'Please enter valid card number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryMonthController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Month',
                  hintText: 'MM',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'MM';
                  }
                  final month = int.tryParse(value);
                  if (month == null || month < 1 || month > 12) {
                    return 'Invalid month';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _expiryYearController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Year',
                  hintText: 'YYYY',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'YYYY';
                  }
                  final year = int.tryParse(value);
                  if (year == null || year < DateTime.now().year) {
                    return 'Invalid year';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: '123',
                  prefixIcon: Icon(Icons.security),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CVV';
                  }
                  if (value.length < 3) {
                    return 'Invalid CVV';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLimitSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Limit Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _limitController,
                decoration: const InputDecoration(
                  labelText: 'Credit Limit',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter credit limit';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            DropdownButtonFormField<Currency>(
              value: _selectedCurrency,
              decoration: const InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
              ),
              items: Currency.values.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(_getCurrencyLabel(currency)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCurrency = value);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Options',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Set as Default Card'),
          subtitle: const Text('This card will be used for new transactions'),
          value: _isDefault,
          onChanged: (value) => setState(() => _isDefault = value),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveCreditCard,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Save Credit Card'),
      ),
    );
  }

  String _getCardTypeLabel(CreditCardType type) {
    switch (type) {
      case CreditCardType.visa:
        return 'Visa';
      case CreditCardType.mastercard:
        return 'Mastercard';
      case CreditCardType.amex:
        return 'American Express';
      case CreditCardType.discover:
        return 'Discover';
      case CreditCardType.rupay:
        return 'RuPay';
    }
  }

  IconData _getCardTypeIcon(CreditCardType type) {
    switch (type) {
      case CreditCardType.visa:
        return Icons.credit_card;
      case CreditCardType.mastercard:
        return Icons.credit_card;
      case CreditCardType.amex:
        return Icons.credit_card;
      case CreditCardType.discover:
        return Icons.credit_card;
      case CreditCardType.rupay:
        return Icons.credit_card;
    }
  }

  String _getCurrencyLabel(Currency currency) {
    switch (currency) {
      case Currency.inr:
        return 'INR (₹)';
      case Currency.usd:
        return 'USD (\$)';
      case Currency.eur:
        return 'EUR (€)';
      case Currency.gbp:
        return 'GBP (£)';
      case Currency.jpy:
        return 'JPY (¥)';
      case Currency.cad:
        return 'CAD (C\$)';
      case Currency.aud:
        return 'AUD (A\$)';
      case Currency.chf:
        return 'CHF (CHF)';
      case Currency.cny:
        return 'CNY (¥)';
    }
  }

  void _saveCreditCard() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save credit card logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credit card saved successfully!')),
      );
      Navigator.pop(context);
    }
  }
}
