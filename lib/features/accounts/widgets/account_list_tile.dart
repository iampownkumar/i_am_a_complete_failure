import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Account List Tile Widget
/// Location: lib/features/accounts/widgets/account_list_tile.dart
/// Purpose: Display individual account information in a list
class AccountListTile extends StatelessWidget {
  final String id;
  final String name;
  final String accountNumber;
  final double balance;
  final String currency;
  final String type;
  final String bankName;
  final bool isDefault;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AccountListTile({
    super.key,
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.balance,
    required this.currency,
    required this.type,
    required this.bankName,
    required this.isDefault,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currencySymbol = _getCurrencySymbol(currency);
    final formattedBalance = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    ).format(balance);

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
                  // Account Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getAccountTypeColor(type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getAccountTypeIcon(type),
                      color: _getAccountTypeColor(type),
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Account Name and Type
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
                          '$type • $bankName',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
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
              
              // Balance and Account Number
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
                            color: _getBalanceColor(balance),
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
                          'Account Number',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '****${accountNumber.substring(accountNumber.length - 4)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      'View Details',
                      Icons.visibility,
                      onTap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      'Transfer',
                      Icons.swap_horiz,
                      () => _navigateToTransfer(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      'History',
                      Icons.history,
                      () => _navigateToHistory(),
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

  /// Build quick action button
  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get account type icon
  IconData _getAccountTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'savings':
        return Icons.savings;
      case 'current':
        return Icons.account_balance;
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'investment':
        return Icons.trending_up;
      case 'credit':
        return Icons.credit_card;
      default:
        return Icons.account_balance;
    }
  }

  /// Get account type color
  Color _getAccountTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'savings':
        return Colors.green;
      case 'current':
        return Colors.blue;
      case 'wallet':
        return Colors.orange;
      case 'investment':
        return Colors.purple;
      case 'credit':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Get balance color based on amount
  Color _getBalanceColor(double balance) {
    if (balance > 0) {
      return Colors.green[600]!;
    } else if (balance < 0) {
      return Colors.red[600]!;
    } else {
      return Colors.grey[600]!;
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

  /// Navigate to transfer screen
  void _navigateToTransfer() {
    // TODO: Implement transfer navigation
    // This will be handled by the parent widget
  }

  /// Navigate to history screen
  void _navigateToHistory() {
    // TODO: Implement history navigation
    // This will be handled by the parent widget
  }
}
