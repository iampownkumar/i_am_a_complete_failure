import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Analytics Summary Card Widget
/// Location: lib/features/analytics/widgets/analytics_summary_card.dart
/// Purpose: Display key financial metrics and overview
class AnalyticsSummaryCard extends StatelessWidget {
  const AnalyticsSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from provider
    final netWorth = 771.0;
    final totalAssets = 771.0;
    final totalDebt = 0.0;
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
                  Icons.analytics,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Financial Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'This Month',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Key Metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    context,
                    'Net Worth',
                    NumberFormat.currency(
                      symbol: currencySymbol,
                      decimalDigits: 0,
                    ).format(netWorth),
                    Icons.account_balance_wallet,
                    Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricItem(
                    context,
                    'Total Assets',
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
                  child: _buildMetricItem(
                    context,
                    'Total Debt',
                    NumberFormat.currency(
                      symbol: currencySymbol,
                      decimalDigits: 0,
                    ).format(totalDebt),
                    Icons.trending_down,
                    Colors.red[300]!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual metric item
  Widget _buildMetricItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
}
