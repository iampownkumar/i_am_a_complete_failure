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

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionBottomSheet(context),
        child: const Icon(Icons.add),
      ),
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
