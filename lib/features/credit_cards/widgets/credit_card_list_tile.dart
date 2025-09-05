import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Credit Card List Tile Widget
/// Location: lib/features/credit_cards/widgets/credit_card_list_tile.dart
/// Purpose: Display individual credit card information in a list
class CreditCardListTile extends StatelessWidget {
  final String id;
  final String name;
  final String lastFourDigits;
  final double balance;
  final double limit;
  final String currency;
  final DateTime dueDate;
  final bool isDefault;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CreditCardListTile({
    super.key,
    required this.id,
    required this.name,
    required this.lastFourDigits,
    required this.balance,
    required this.limit,
    required this.currency,
    required this.dueDate,
    required this.isDefault,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final usagePercentage = (balance / limit) * 100;
    final currencySymbol = _getCurrencySymbol(currency);
    final formattedBalance = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    ).format(balance);
    final formattedLimit = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    ).format(limit);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Credit Card Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.credit_card,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Card Name and Last Four Digits
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '**** **** **** $lastFourDigits',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Default Badge
                  if (isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'DEFAULT',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  
                  // Menu Button
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Balance and Limit
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Balance',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedBalance,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getBalanceColor(usagePercentage),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Credit Limit',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedLimit,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Usage Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Usage',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${usagePercentage.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getBalanceColor(usagePercentage),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: usagePercentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getBalanceColor(usagePercentage),
                    ),
                    minHeight: 6,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Due Date and Available Credit
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Due Date',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(dueDate),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Available Credit',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          NumberFormat.currency(
                            symbol: currencySymbol,
                            decimalDigits: 0,
                          ).format(limit - balance),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
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

  /// Get balance color based on usage percentage
  Color _getBalanceColor(double usagePercentage) {
    if (usagePercentage >= 90) {
      return Colors.red;
    } else if (usagePercentage >= 75) {
      return Colors.orange;
    } else if (usagePercentage >= 50) {
      return Colors.amber;
    } else {
      return Colors.green;
    }
  }
}
