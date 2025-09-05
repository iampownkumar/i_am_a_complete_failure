import 'package:flutter/material.dart';
import '../widgets/account_list_tile.dart';
import '../widgets/account_summary_card.dart';
import 'add_account_screen.dart';

/// Accounts Screen - Main screen for managing bank accounts and wallets
/// Location: lib/features/accounts/screens/accounts_screen.dart
/// Purpose: Display all accounts, balances, and quick actions
class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddAccount(context),
            tooltip: 'Add Account',
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
              // Account Summary Card
              const AccountSummaryCard(),
              
              const SizedBox(height: 24),
              
              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Accounts',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _navigateToAddAccount(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Account'),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Accounts List
              _buildAccountsList(),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              _buildQuickActions(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddAccount(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Account'),
      ),
    );
  }

  /// Build the list of accounts
  Widget _buildAccountsList() {
    // TODO: Replace with actual data from provider
    final List<Map<String, dynamic>> accounts = [
      {
        'id': '1',
        'name': 'HDFC Savings Account',
        'accountNumber': '1234567890',
        'balance': 45000.0,
        'currency': 'INR',
        'type': 'Savings',
        'bankName': 'HDFC Bank',
        'isDefault': true,
      },
      {
        'id': '2',
        'name': 'SBI Current Account',
        'accountNumber': '9876543210',
        'balance': 25000.0,
        'currency': 'INR',
        'type': 'Current',
        'bankName': 'State Bank of India',
        'isDefault': false,
      },
      {
        'id': '3',
        'name': 'Paytm Wallet',
        'accountNumber': '9876543210',
        'balance': 2500.0,
        'currency': 'INR',
        'type': 'Wallet',
        'bankName': 'Paytm',
        'isDefault': false,
      },
    ];

    if (accounts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: accounts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final account = accounts[index];
        return AccountListTile(
          id: account['id'],
          name: account['name'],
          accountNumber: account['accountNumber'],
          balance: account['balance'],
          currency: account['currency'],
          type: account['type'],
          bankName: account['bankName'],
          isDefault: account['isDefault'],
          onTap: () => _navigateToAccountDetails(account['id']),
          onEdit: () => _navigateToEditAccount(account['id']),
          onDelete: () => _showDeleteConfirmation(account['id'], account['name']),
        );
      },
    );
  }

  /// Build empty state when no accounts exist
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Accounts',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first account to start tracking your finances',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddAccount(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Account'),
          ),
        ],
      ),
    );
  }

  /// Build quick actions section
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.swap_horiz,
                title: 'Transfer Money',
                subtitle: 'Between accounts',
                onTap: () => _navigateToTransferMoney(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.analytics,
                title: 'View Analytics',
                subtitle: 'Account insights',
                onTap: () => _navigateToAccountAnalytics(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.settings,
                title: 'Account Settings',
                subtitle: 'Manage preferences',
                onTap: () => _navigateToAccountSettings(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.history,
                title: 'Transaction History',
                subtitle: 'View all transactions',
                onTap: () => _navigateToTransactionHistory(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build individual quick action card
  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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

  /// Navigate to edit account screen
  void _navigateToEditAccount(String accountId) {
    // TODO: Implement edit account navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit account $accountId - Coming Soon')),
    );
  }

  /// Navigate to account details screen
  void _navigateToAccountDetails(String accountId) {
    // TODO: Implement account details navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account details $accountId - Coming Soon')),
    );
  }

  /// Navigate to transfer money screen
  void _navigateToTransferMoney() {
    // TODO: Implement transfer money navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transfer Money - Coming Soon')),
    );
  }

  /// Navigate to account analytics screen
  void _navigateToAccountAnalytics() {
    // TODO: Implement account analytics navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account Analytics - Coming Soon')),
    );
  }

  /// Navigate to account settings screen
  void _navigateToAccountSettings() {
    // TODO: Implement account settings navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account Settings - Coming Soon')),
    );
  }

  /// Navigate to transaction history screen
  void _navigateToTransactionHistory() {
    // TODO: Implement transaction history navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction History - Coming Soon')),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(String accountId, String accountName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text('Are you sure you want to delete $accountName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount(accountId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Delete account
  void _deleteAccount(String accountId) {
    // TODO: Implement delete account logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Delete account $accountId - Coming Soon')),
    );
  }
}
