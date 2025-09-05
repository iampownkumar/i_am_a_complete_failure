import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Account Summary Card Widget
/// Location: lib/features/accounts/widgets/account_summary_card.dart
/// Purpose: Display overall account summary with total balances
class AccountSummaryCard extends StatelessWidget {
  const AccountSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from provider
    final totalBalance = 72500.0;
    final totalAssets = 72500.0;
    final totalLiabilities = 0.0;
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
                  Icons.account_balance,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Accounts Overview',
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
                        'Net Worth',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        NumberFormat.currency(
                          symbol: currencySymbol,
                          decimalDigits: 0,
                        ).format(totalAssets - totalLiabilities),
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
            
            // Assets and Liabilities
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Assets',
                    NumberFormat.currency(
                      symbol: currencySymbol,
                      decimalDigits: 0,
                    ).format(totalAssets),
                    Icons.trending_up,
                    Colors.green[300]!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Liabilities',
                    NumberFormat.currency(
                      symbol: currencySymbol,
                      decimalDigits: 0,
                    ).format(totalLiabilities),
                    Icons.trending_down,
                    Colors.red[300]!,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Account Count and Quick Actions
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Active Accounts',
                    '3', // TODO: Get from actual data
                    Icons.account_balance,
                    Colors.blue[300]!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Total Transactions',
                    '127', // TODO: Get from actual data
                    Icons.receipt,
                    Colors.orange[300]!,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    'Add Account',
                    Icons.add,
                    () => _navigateToAddAccount(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    'Transfer Money',
                    Icons.swap_horiz,
                    () => _navigateToTransferMoney(context),
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

  /// Navigate to add account screen
  void _navigateToAddAccount(BuildContext context) {
    // TODO: Implement add account navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Account - Coming Soon')),
    );
  }

  /// Navigate to transfer money screen
  void _navigateToTransferMoney(BuildContext context) {
    // TODO: Implement transfer money navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transfer Money - Coming Soon')),
    );
  }
}
