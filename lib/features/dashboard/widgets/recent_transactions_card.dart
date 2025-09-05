// File: lib/features/dashboard/widgets/recent_transactions_card.dart
// Purpose: Recent transactions card showing latest transactions

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors/app_colors.dart';
import '../../../core/constants/strings/app_strings.dart';
import '../../../core/constants/enums/app_enums.dart';

class RecentTransactionsCard extends StatelessWidget {
  const RecentTransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.recentTransactions,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _navigateToAllTransactions(context),
              child: Text(AppStrings.viewAll),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTransactionsList(context),
      ],
    );
  }

  /// Build transactions list
  Widget _buildTransactionsList(BuildContext context) {
    // TODO: Replace with actual data from provider
    final List<Map<String, dynamic>> recentTransactions = [
      {
        'id': '1',
        'title': 'Grocery Shopping',
        'amount': -2500.0,
        'category': 'Food & Dining',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'type': TransactionType.expense,
        'account': 'HDFC Savings',
      },
      {
        'id': '2',
        'title': 'Salary Credit',
        'amount': 50000.0,
        'category': 'Salary',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'type': TransactionType.income,
        'account': 'HDFC Savings',
      },
      {
        'id': '3',
        'title': 'Coffee Shop',
        'amount': -150.0,
        'category': 'Food & Dining',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'type': TransactionType.expense,
        'account': 'Paytm Wallet',
      },
      {
        'id': '4',
        'title': 'Uber Ride',
        'amount': -180.0,
        'category': 'Transportation',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'type': TransactionType.expense,
        'account': 'HDFC Savings',
      },
    ];

    if (recentTransactions.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: recentTransactions.take(3).map((transaction) {
          return _buildTransactionItem(context, transaction);
        }).toList(),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            size: 48,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noTransactionsYet,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.addFirstTransaction,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build individual transaction item
  Widget _buildTransactionItem(BuildContext context, Map<String, dynamic> transaction) {
    final isExpense = transaction['amount'] < 0;
    final amount = transaction['amount'].abs();
    final formattedAmount = NumberFormat.currency(symbol: '₹', decimalDigits: 0).format(amount);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Category Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getCategoryColor(transaction['category']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(transaction['category']),
              color: _getCategoryColor(transaction['category']),
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction['category']} • ${transaction['account']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a').format(transaction['date']),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isExpense ? '-' : '+'}$formattedAmount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isExpense ? Colors.red : Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isExpense ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  transaction['type'].name.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isExpense ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get category icon
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
        return Icons.restaurant;
      case 'salary':
        return Icons.work;
      case 'transportation':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills & utilities':
        return Icons.receipt;
      case 'healthcare':
        return Icons.medical_services;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      default:
        return Icons.category;
    }
  }

  /// Get category color
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
        return Colors.orange;
      case 'salary':
        return Colors.green;
      case 'transportation':
        return Colors.blue;
      case 'shopping':
        return Colors.purple;
      case 'entertainment':
        return Colors.pink;
      case 'bills & utilities':
        return Colors.red;
      case 'healthcare':
        return Colors.teal;
      case 'education':
        return Colors.indigo;
      case 'travel':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  /// Navigate to all transactions
  void _navigateToAllTransactions(BuildContext context) {
    // TODO: Implement navigation to all transactions screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All Transactions - Coming Soon')),
    );
  }
}
