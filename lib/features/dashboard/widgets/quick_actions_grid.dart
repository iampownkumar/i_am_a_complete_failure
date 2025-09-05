// File: lib/features/dashboard/widgets/quick_actions_grid.dart
// Purpose: Quick actions grid for common app functions

import 'package:flutter/material.dart';
import '../../../core/constants/colors/app_colors.dart';
import '../../../core/constants/strings/app_strings.dart';
import '../../transactions/screens/add_transaction_screen.dart';
import '../../transactions/screens/transfer_money_screen.dart';
import '../../accounts/screens/add_account_screen.dart';
import '../../credit_cards/screens/add_credit_card_screen.dart';
import '../../sms/screens/sms_parsing_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.quickActions,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.0,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _ActionCard(
              title: AppStrings.addTransaction,
              icon: Icons.add,
              color: AppColors.primary,
              onTap: () => _navigateToAddTransaction(context),
            ),
            _ActionCard(
              title: AppStrings.transferMoney,
              icon: Icons.swap_horiz,
              color: AppColors.info,
              onTap: () => _navigateToTransferMoney(context),
            ),
            _ActionCard(
              title: AppStrings.addAccount,
              icon: Icons.account_balance,
              color: AppColors.success,
              onTap: () => _navigateToAddAccount(context),
            ),
            _ActionCard(
              title: AppStrings.addCreditCard,
              icon: Icons.credit_card,
              color: AppColors.warning,
              onTap: () => _navigateToAddCreditCard(context),
            ),
            _ActionCard(
              title: 'SMS Parsing',
              icon: Icons.sms,
              color: AppColors.secondary,
              onTap: () => _navigateToSmsParsing(context),
            ),
            _ActionCard(
              title: 'Analytics',
              icon: Icons.analytics,
              color: AppColors.purple,
              onTap: () => _navigateToAnalytics(context),
            ),
          ],
        ),
      ],
    );
  }

  /// Navigate to add transaction screen
  void _navigateToAddTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
  }

  /// Navigate to transfer money screen
  void _navigateToTransferMoney(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TransferMoneyScreen(),
      ),
    );
  }

  /// Navigate to add account screen
  void _navigateToAddAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddAccountScreen(),
      ),
    );
  }

  /// Navigate to add credit card screen
  void _navigateToAddCreditCard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCreditCardScreen(),
      ),
    );
  }

  /// Navigate to SMS parsing screen
  void _navigateToSmsParsing(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SmsParsingScreen(),
      ),
    );
  }

  /// Navigate to analytics screen
  void _navigateToAnalytics(BuildContext context) {
    // Switch to analytics tab in main navigation
    // This will be handled by the parent navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Switch to Analytics tab to view detailed analytics')),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
