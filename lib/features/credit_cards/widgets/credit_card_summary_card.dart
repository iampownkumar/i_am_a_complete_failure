import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Credit Card Summary Card Widget
/// Location: lib/features/credit_cards/widgets/credit_card_summary_card.dart
/// Purpose: Display overall credit card summary with total balances and limits
class CreditCardSummaryCard extends StatelessWidget {
  const CreditCardSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from provider
    final totalBalance = 23500.0;
    final totalLimit = 80000.0;
    final totalAvailable = totalLimit - totalBalance;
    final usagePercentage = (totalBalance / totalLimit) * 100;
    final currency = 'INR';
    final currencySymbol = _getCurrencySymbol(currency);

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.credit_card,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Credit Cards Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Total Balance
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        NumberFormat.currency(
                          symbol: currencySymbol,
                          decimalDigits: 0,
                        ).format(totalBalance),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                        'Total Limit',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        NumberFormat.currency(
                          symbol: currencySymbol,
                          decimalDigits: 0,
                        ).format(totalLimit),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Usage Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Credit Usage',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '${usagePercentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: usagePercentage / 100,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getUsageColor(usagePercentage),
                  ),
                  minHeight: 8,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Available Credit and Cards Count
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Available Credit',
                    NumberFormat.currency(
                      symbol: currencySymbol,
                      decimalDigits: 0,
                    ).format(totalAvailable),
                    Icons.account_balance_wallet,
                    Colors.green[300]!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Active Cards',
                    '2', // TODO: Get from actual data
                    Icons.credit_card,
                    Colors.blue[300]!,
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
                    'Make Payment',
                    Icons.payment,
                    () => _navigateToMakePayment(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    'Add Card',
                    Icons.add,
                    () => _navigateToAddCard(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual stat item
  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build quick action button
  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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

  /// Get usage color based on percentage
  Color _getUsageColor(double percentage) {
    if (percentage >= 90) {
      return Colors.red[300]!;
    } else if (percentage >= 75) {
      return Colors.orange[300]!;
    } else if (percentage >= 50) {
      return Colors.amber[300]!;
    } else {
      return Colors.green[300]!;
    }
  }

  /// Navigate to make payment screen
  void _navigateToMakePayment(BuildContext context) {
    // TODO: Implement make payment navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Make Payment - Coming Soon')),
    );
  }

  /// Navigate to add card screen
  void _navigateToAddCard(BuildContext context) {
    // TODO: Implement add card navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Card - Coming Soon')),
    );
  }
}
