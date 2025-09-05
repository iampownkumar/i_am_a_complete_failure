import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Spending Category Card Widget
/// Location: lib/features/analytics/widgets/spending_category_card.dart
/// Purpose: Display spending breakdown by category
class SpendingCategoryCard extends StatelessWidget {
  final String category;
  final double amount;
  final double percentage;
  final Color color;
  final VoidCallback? onTap;

  const SpendingCategoryCard({
    super.key,
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencySymbol = _getCurrencySymbol('INR'); // TODO: Get from context
    final formattedAmount = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    ).format(amount);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: color,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Category Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedAmount,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Percentage and Progress
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 60,
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get category icon based on category name
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
        return Icons.restaurant;
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
      case 'groceries':
        return Icons.shopping_cart;
      case 'fuel':
        return Icons.local_gas_station;
      default:
        return Icons.category;
    }
  }

  /// Get currency symbol based on currency code
  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      default:
        return currency;
    }
  }
}
