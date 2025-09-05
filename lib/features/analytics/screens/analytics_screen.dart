import 'package:flutter/material.dart';
import '../widgets/analytics_chart.dart';
import '../widgets/analytics_summary_card.dart';

/// Analytics Screen - Main screen for financial analytics and insights
/// Location: lib/features/analytics/screens/analytics_screen.dart
/// Purpose: Display comprehensive financial analytics, charts, and insights
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = [
    'This Month',
    'Last Month',
    'This Year',
    'Last Year',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
            tooltip: 'Filter Options',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh logic
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Analysis Period Selector
              _buildPeriodSelector(),
              
              const SizedBox(height: 24),
              
              // Financial Overview Card
              const AnalyticsSummaryCard(),
              
              const SizedBox(height: 24),
              
              // Spending Analysis Section
              _buildSpendingAnalysisSection(),
              
              const SizedBox(height: 24),
              
              // Net Worth Tracking Section
              _buildNetWorthSection(),
              
              const SizedBox(height: 24),
              
              // Spending by Category
              _buildSpendingByCategorySection(),
              
              const SizedBox(height: 24),
              
              // Monthly Trends Chart
              _buildMonthlyTrendsSection(),
              
              const SizedBox(height: 24),
              
              // Account Performance
              _buildAccountPerformanceSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build period selector
  Widget _buildPeriodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Period',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _periods.map((period) {
              final isSelected = period == _selectedPeriod;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilterChip(
                  label: Text(period),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                  selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Build spending analysis section
  Widget _buildSpendingAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spending Analysis',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildSpendingMetric(
                        'Income',
                        '₹0.00',
                        Icons.trending_up,
                        Colors.green,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: _buildSpendingMetric(
                        'Expenses',
                        '₹0.00',
                        Icons.trending_down,
                        Colors.red,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: _buildSpendingMetric(
                        'Net',
                        '₹0.00',
                        Icons.account_balance,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build net worth section
  Widget _buildNetWorthSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Net Worth Tracking',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildNetWorthMetric(
                        'Current',
                        '₹771.00',
                        Icons.account_balance_wallet,
                        Colors.blue,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: _buildNetWorthMetric(
                        'Assets',
                        '₹771.00',
                        Icons.trending_up,
                        Colors.green,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: _buildNetWorthMetric(
                        'Liabilities',
                        '₹0.00',
                        Icons.trending_down,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Net worth is calculated as total assets minus total liabilities. This includes all accounts, investments, and outstanding debts.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build spending by category section
  Widget _buildSpendingByCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spending by Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // TODO: Replace with actual category data
                _buildCategoryItem('Food & Dining', 0.0, 0.0, Colors.orange),
                _buildCategoryItem('Transportation', 0.0, 0.0, Colors.blue),
                _buildCategoryItem('Shopping', 0.0, 0.0, Colors.purple),
                _buildCategoryItem('Entertainment', 0.0, 0.0, Colors.green),
                _buildCategoryItem('Bills & Utilities', 0.0, 0.0, Colors.red),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build monthly trends section
  Widget _buildMonthlyTrendsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Trends',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const AnalyticsChart(),
                const SizedBox(height: 16),
                Text(
                  'No data available for the selected period',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build account performance section
  Widget _buildAccountPerformanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Performance',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'No account performance data available',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _navigateToAddAccount(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Account'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build spending metric
  Widget _buildSpendingMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Build net worth metric
  Widget _buildNetWorthMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Build category item
  Widget _buildCategoryItem(
    String category,
    double amount,
    double percentage,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Show filter options
  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Options',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // TODO: Implement filter options
            Text(
              'Filter options will be available soon',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigate to add account
  void _navigateToAddAccount() {
    // TODO: Implement add account navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Account - Coming Soon')),
    );
  }
}
