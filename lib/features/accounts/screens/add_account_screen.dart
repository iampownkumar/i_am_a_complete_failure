// File: lib/features/accounts/screens/add_account_screen.dart
// Purpose: Add new account screen

import 'package:flutter/material.dart';
import '../../../core/constants/strings/app_strings.dart';
import '../../../core/constants/enums/app_enums.dart';
import '../../../core/constants/colors/app_colors.dart';
import '../../../shared/models/account.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _balanceController = TextEditingController();
  
  AccountType _selectedAccountType = AccountType.savings;
  Currency _selectedCurrency = Currency.inr;
  bool _isDefault = false;

  @override
  void dispose() {
    _nameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveAccount,
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
              // Account Type Selection
              _buildAccountTypeSection(),
              
              const SizedBox(height: 24),
              
              // Basic Information
              _buildBasicInfoSection(),
              
              const SizedBox(height: 24),
              
              // Bank Information
              _buildBankInfoSection(),
              
              const SizedBox(height: 24),
              
              // Balance Information
              _buildBalanceSection(),
              
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

  Widget _buildAccountTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AccountType.values.map((type) {
            final isSelected = _selectedAccountType == type;
            return GestureDetector(
              onTap: () => setState(() => _selectedAccountType = type),
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
                      _getAccountTypeIcon(type),
                      color: isSelected ? Colors.white : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getAccountTypeLabel(type),
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
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Account Name',
            hintText: 'e.g., My Savings Account',
            prefixIcon: Icon(Icons.account_balance),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _accountNumberController,
          decoration: const InputDecoration(
            labelText: 'Account Number',
            hintText: 'e.g., 1234567890',
            prefixIcon: Icon(Icons.credit_card),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBankInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bankNameController,
          decoration: const InputDecoration(
            labelText: 'Bank Name',
            hintText: 'e.g., HDFC Bank',
            prefixIcon: Icon(Icons.business),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter bank name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBalanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Balance Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _balanceController,
                decoration: const InputDecoration(
                  labelText: 'Current Balance',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter balance';
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
          title: const Text('Set as Default Account'),
          subtitle: const Text('This account will be used for new transactions'),
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
        onPressed: _saveAccount,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Save Account'),
      ),
    );
  }

  String _getAccountTypeLabel(AccountType type) {
    switch (type) {
      case AccountType.savings:
        return 'Savings';
      case AccountType.checking:
        return 'Checking';
      case AccountType.investment:
        return 'Investment';
      case AccountType.loan:
        return 'Loan';
      case AccountType.credit:
        return 'Credit';
      case AccountType.cash:
        return 'Cash';
    }
  }

  IconData _getAccountTypeIcon(AccountType type) {
    switch (type) {
      case AccountType.savings:
        return Icons.account_balance;
      case AccountType.checking:
        return Icons.business;
      case AccountType.investment:
        return Icons.trending_up;
      case AccountType.loan:
        return Icons.account_balance_wallet;
      case AccountType.credit:
        return Icons.credit_card;
      case AccountType.cash:
        return Icons.money;
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

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save account logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account saved successfully!')),
      );
      Navigator.pop(context);
    }
  }
}
