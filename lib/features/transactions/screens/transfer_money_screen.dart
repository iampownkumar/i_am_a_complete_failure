// File: lib/features/transactions/screens/transfer_money_screen.dart
// Purpose: Transfer money between accounts screen

import 'package:flutter/material.dart';
import '../../../core/constants/strings/app_strings.dart';
import '../../../core/constants/enums/app_enums.dart';
import '../../../core/constants/colors/app_colors.dart';

class TransferMoneyScreen extends StatefulWidget {
  const TransferMoneyScreen({super.key});

  @override
  State<TransferMoneyScreen> createState() => _TransferMoneyScreenState();
}

class _TransferMoneyScreenState extends State<TransferMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _fromAccount = '';
  String _toAccount = '';
  Currency _selectedCurrency = Currency.inr;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Money'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _transferMoney,
            child: const Text('Transfer'),
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
              // Amount Section
              _buildAmountSection(),
              
              const SizedBox(height: 24),
              
              // From Account Section
              _buildFromAccountSection(),
              
              const SizedBox(height: 24),
              
              // To Account Section
              _buildToAccountSection(),
              
              const SizedBox(height: 24),
              
              // Description Section
              _buildDescriptionSection(),
              
              const SizedBox(height: 24),
              
              // Date Section
              _buildDateSection(),
              
              const SizedBox(height: 32),
              
              // Transfer Button
              _buildTransferButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transfer Amount',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
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

  Widget _buildFromAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From Account',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _fromAccount.isEmpty ? null : _fromAccount,
          decoration: const InputDecoration(
            labelText: 'Select Source Account',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_balance),
          ),
          items: _getAccounts().map((account) {
            return DropdownMenuItem(
              value: account['id'],
              child: Text(account['name']!),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _fromAccount = value ?? '');
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select source account';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildToAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'To Account',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _toAccount.isEmpty ? null : _toAccount,
          decoration: const InputDecoration(
            labelText: 'Select Destination Account',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_balance_wallet),
          ),
          items: _getAccounts().map((account) {
            return DropdownMenuItem(
              value: account['id'],
              child: Text(account['name']!),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _toAccount = value ?? '');
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select destination account';
            }
            if (value == _fromAccount) {
              return 'Source and destination accounts must be different';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Transfer Description',
            hintText: 'e.g., Monthly savings transfer',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter description';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transfer Date',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _selectDate,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Date',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransferButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _transferMoney,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Transfer Money'),
      ),
    );
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

  List<Map<String, String>> _getAccounts() {
    // TODO: Load from database
    return [
      {'id': '1', 'name': 'HDFC Savings Account'},
      {'id': '2', 'name': 'SBI Current Account'},
      {'id': '3', 'name': 'Paytm Wallet'},
    ];
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _transferMoney() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement transfer money logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transfer completed successfully!')),
      );
      Navigator.pop(context);
    }
  }
}
