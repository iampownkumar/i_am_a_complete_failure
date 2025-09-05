// File: lib/features/dashboard/screens/dashboard_screen.dart
// Purpose: Main dashboard screen showing financial overview and quick actions

import 'package:flutter/material.dart';
import '../../../core/constants/colors/app_colors.dart';
import '../../../core/constants/strings/app_strings.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_stats_grid.dart';
import '../widgets/account_summary_card.dart';
import '../widgets/recent_transactions_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../../transactions/screens/add_transaction_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _DashboardContent(),
          _AccountsContent(),
          _CreditCardsContent(),
          _AnalyticsContent(),
          _MoreContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: AppStrings.dashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: AppStrings.accounts,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: AppStrings.creditCards,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: AppStrings.analytics,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: AppStrings.more,
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showAddTransactionBottomSheet(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showAddTransactionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const AddTransactionScreen(),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeader(),
            const SizedBox(height: 24),
            const QuickStatsGrid(),
            const SizedBox(height: 24),
            const AccountSummaryCard(),
            const SizedBox(height: 24),
            const RecentTransactionsCard(),
            const SizedBox(height: 24),
            const QuickActionsGrid(),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }
}

class _AccountsContent extends StatelessWidget {
  const _AccountsContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Accounts Screen - Coming Soon'),
    );
  }
}

class _CreditCardsContent extends StatelessWidget {
  const _CreditCardsContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Credit Cards Screen - Coming Soon'),
    );
  }
}

class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Analytics Screen - Coming Soon'),
    );
  }
}

class _MoreContent extends StatelessWidget {
  const _MoreContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('More Screen - Coming Soon'),
    );
  }
}
