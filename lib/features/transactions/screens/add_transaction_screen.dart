// File: lib/features/transactions/screens/add_transaction_screen.dart
// Purpose: Full-screen add transaction form with comprehensive input fields

import 'package:flutter/material.dart';
import '../../../core/constants/colors/app_colors.dart';
import '../../../core/constants/strings/app_strings.dart';
import '../../../core/constants/enums/app_enums.dart';
import '../../../shared/models/transaction.dart';
import '../../../core/services/database/database_service.dart';
import '../../../core/errors/handlers/error_handler.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;
  
  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  
  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = 'Food & Dining';
  String? _selectedSubCategory;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedAccountId;
  String? _selectedCreditCardId;
  String? _selectedTransferToAccountId;
  List<String> _tags = [];
  Currency _selectedCurrency = Currency.inr;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _loadTransactionData();
    }
  }

  void _loadTransactionData() {
    final transaction = widget.transaction!;
    _amountController.text = transaction.amount.toString();
    _descriptionController.text = transaction.description;
    _notesController.text = transaction.notes ?? '';
    _selectedType = transaction.type;
    _selectedCategory = transaction.category;
    _selectedSubCategory = transaction.subCategory;
    _selectedDate = transaction.date;
    _selectedTime = TimeOfDay.fromDateTime(transaction.date);
    _selectedAccountId = transaction.accountId;
    _selectedCreditCardId = transaction.creditCardId;
    _selectedTransferToAccountId = transaction.transferToAccountId;
    _tags = List.from(transaction.tags);
    _selectedCurrency = transaction.currency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction != null 
              ? AppStrings.editTransaction 
              : AppStrings.addNewTransaction,
        ),
        actions: [
          if (widget.transaction != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTransaction,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTransactionTypeSection(),
              const SizedBox(height: 24),
              _buildAmountSection(),
              const SizedBox(height: 24),
              _buildDescriptionSection(),
              const SizedBox(height: 24),
              _buildCategorySection(),
              const SizedBox(height: 24),
              _buildDateSection(),
              const SizedBox(height: 24),
              _buildAccountSection(),
              const SizedBox(height: 24),
              _buildNotesSection(),
              const SizedBox(height: 24),
              _buildTagsSection(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.transactionType,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: TransactionType.values.map((type) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_getTransactionTypeLabel(type)),
                  selected: _selectedType == type,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                  selectedColor: _getTransactionTypeColor(type).withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: _selectedType == type 
                        ? _getTransactionTypeColor(type)
                        : AppColors.textSecondary,
                    fontWeight: _selectedType == type 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: _getCurrencySymbol(_selectedCurrency),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.requiredField;
                  }
                  if (double.tryParse(value) == null) {
                    return AppStrings.invalidAmount;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<Currency>(
              value: _selectedCurrency,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
              items: Currency.values.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency.name.toUpperCase()),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.description,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: 'Enter transaction description',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.requiredField;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.category,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _selectedCategory,
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
              _selectedSubCategory = null;
            });
          },
          items: _getCategories().map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          decoration: const InputDecoration(
            hintText: 'Select category',
          ),
        ),
        if (_selectedCategory.isNotEmpty) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedSubCategory,
            onChanged: (value) {
              setState(() {
                _selectedSubCategory = value;
              });
            },
            items: _getSubCategories(_selectedCategory).map((subCategory) {
              return DropdownMenuItem(
                value: subCategory,
                child: Text(subCategory),
              );
            }).toList(),
            decoration: const InputDecoration(
              hintText: 'Select sub category (optional)',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.date,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedTime.format(context)),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedType == TransactionType.transfer ? 'From Account' : AppStrings.account,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _selectedAccountId,
          onChanged: (value) {
            setState(() {
              _selectedAccountId = value;
            });
          },
          items: _getAccounts().map((account) {
            return DropdownMenuItem(
              value: account['id'],
              child: Text(account['name']!),
            );
          }).toList(),
          decoration: const InputDecoration(
            hintText: 'Select account',
          ),
        ),
        if (_selectedType == TransactionType.transfer) ...[
          const SizedBox(height: 12),
          Text(
            'To Account',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedTransferToAccountId,
            onChanged: (value) {
              setState(() {
                _selectedTransferToAccountId = value;
              });
            },
            items: _getAccounts().map((account) {
              return DropdownMenuItem(
                value: account['id'],
                child: Text(account['name']!),
              );
            }).toList(),
            decoration: const InputDecoration(
              hintText: 'Select destination account',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.notes,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Add notes (optional)',
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.tags,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tags.map((tag) {
            return Chip(
              label: Text(tag),
              onDeleted: () {
                setState(() {
                  _tags.remove(tag);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Add tag and press Enter',
            suffixIcon: Icon(Icons.add),
          ),
          onFieldSubmitted: (value) {
            if (value.isNotEmpty && !_tags.contains(value)) {
              setState(() {
                _tags.add(value);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : _cancel,
            child: Text(AppStrings.cancel),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveTransaction,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(AppStrings.save),
          ),
        ),
      ],
    );
  }

  // Helper methods
  String _getTransactionTypeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return AppStrings.income;
      case TransactionType.expense:
        return AppStrings.expense;
      case TransactionType.transfer:
        return AppStrings.transfer;
      case TransactionType.investment:
        return 'Investment';
    }
  }

  Color _getTransactionTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return AppColors.success;
      case TransactionType.expense:
        return AppColors.error;
      case TransactionType.transfer:
        return AppColors.info;
      case TransactionType.investment:
        return AppColors.purple;
    }
  }

  String _getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.inr:
        return '₹';
      case Currency.usd:
        return '\$';
      case Currency.eur:
        return '€';
      case Currency.gbp:
        return '£';
      case Currency.jpy:
        return '¥';
      case Currency.cad:
        return 'C\$';
      case Currency.aud:
        return 'A\$';
      case Currency.chf:
        return 'CHF';
      case Currency.cny:
        return '¥';
    }
  }

  List<String> _getCategories() {
    return [
      'Food & Dining',
      'Transportation',
      'Shopping',
      'Entertainment',
      'Bills & Utilities',
      'Healthcare',
      'Education',
      'Travel',
      'Salary',
      'Freelance',
      'Investment',
      'Bonus',
      'Refund',
    ];
  }

  List<String> _getSubCategories(String category) {
    // TODO: Implement subcategories based on category
    return [];
  }

  List<Map<String, String>> _getAccounts() {
    // TODO: Load from database
    return [
      {'id': '1', 'name': 'Savings (SBI)'},
      {'id': '2', 'name': 'Savings (HDFC)'},
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
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final transaction = widget.transaction != null
          ? widget.transaction!.copyWith(
              type: _selectedType,
              amount: double.parse(_amountController.text),
              description: _descriptionController.text,
              category: _selectedCategory,
              subCategory: _selectedSubCategory,
              date: dateTime,
              accountId: _selectedAccountId,
              creditCardId: _selectedCreditCardId,
              transferToAccountId: _selectedTransferToAccountId,
              tags: _tags,
              notes: _notesController.text.isEmpty ? null : _notesController.text,
              currency: _selectedCurrency,
              updatedAt: DateTime.now(),
            )
          : Transaction.create(
              type: _selectedType,
              amount: double.parse(_amountController.text),
              description: _descriptionController.text,
              category: _selectedCategory,
              subCategory: _selectedSubCategory,
              date: dateTime,
              accountId: _selectedAccountId,
              creditCardId: _selectedCreditCardId,
              transferToAccountId: _selectedTransferToAccountId,
              tags: _tags,
              notes: _notesController.text.isEmpty ? null : _notesController.text,
              currency: _selectedCurrency,
            );

      if (widget.transaction != null) {
        await DatabaseService.instance.updateTransaction(transaction);
        ErrorHandler.showSnackBar(context, AppStrings.transactionUpdated);
      } else {
        await DatabaseService.instance.insertTransaction(transaction);
        ErrorHandler.showSnackBar(context, AppStrings.transactionAdded);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTransaction() async {
    if (widget.transaction == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await DatabaseService.instance.deleteTransaction(widget.transaction!.id);
        ErrorHandler.showSnackBar(context, AppStrings.transactionDeleted);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        ErrorHandler.handleError(context, e);
      }
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
