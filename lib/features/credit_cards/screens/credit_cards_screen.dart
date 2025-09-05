import 'package:flutter/material.dart';
import '../widgets/credit_card_list_tile.dart';
import '../widgets/credit_card_summary_card.dart';
import 'add_credit_card_screen.dart';

/// Credit Cards Screen - Main screen for managing credit cards
/// Location: lib/features/credit_cards/screens/credit_cards_screen.dart
/// Purpose: Display all credit cards, balances, limits, and quick actions
class CreditCardsScreen extends StatefulWidget {
  const CreditCardsScreen({super.key});

  @override
  State<CreditCardsScreen> createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Cards'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddCreditCard(context),
            tooltip: 'Add Credit Card',
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
              // Credit Card Summary Card
              const CreditCardSummaryCard(),
              
              const SizedBox(height: 24),
              
              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Credit Cards',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _navigateToAddCreditCard(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Card'),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Credit Cards List
              _buildCreditCardsList(),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              _buildQuickActions(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddCreditCard(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Credit Card'),
      ),
    );
  }

  /// Build the list of credit cards
  Widget _buildCreditCardsList() {
    // TODO: Replace with actual data from provider
    final List<Map<String, dynamic>> creditCards = [
      {
        'id': '1',
        'name': 'HDFC Bank Credit Card',
        'lastFourDigits': '1234',
        'balance': 15000.0,
        'limit': 50000.0,
        'currency': 'INR',
        'dueDate': DateTime.now().add(const Duration(days: 15)),
        'isDefault': true,
      },
      {
        'id': '2',
        'name': 'SBI Credit Card',
        'lastFourDigits': '5678',
        'balance': 8500.0,
        'limit': 30000.0,
        'currency': 'INR',
        'dueDate': DateTime.now().add(const Duration(days: 8)),
        'isDefault': false,
      },
    ];

    if (creditCards.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: creditCards.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final card = creditCards[index];
        return CreditCardListTile(
          id: card['id'],
          name: card['name'],
          lastFourDigits: card['lastFourDigits'],
          balance: card['balance'],
          limit: card['limit'],
          currency: card['currency'],
          dueDate: card['dueDate'],
          isDefault: card['isDefault'],
          onTap: () => _navigateToCreditCardDetails(card['id']),
          onEdit: () => _navigateToEditCreditCard(card['id']),
          onDelete: () => _showDeleteConfirmation(card['id'], card['name']),
        );
      },
    );
  }

  /// Build empty state when no credit cards exist
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.credit_card_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Credit Cards',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first credit card to start tracking expenses',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddCreditCard(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Credit Card'),
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
                icon: Icons.payment,
                title: 'Make Payment',
                subtitle: 'Pay credit card bill',
                onTap: () => _navigateToMakePayment(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.analytics,
                title: 'View Analytics',
                subtitle: 'Spending insights',
                onTap: () => _navigateToCreditCardAnalytics(),
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
                title: 'Card Settings',
                subtitle: 'Manage preferences',
                onTap: () => _navigateToCardSettings(),
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

  /// Navigate to add credit card screen
  void _navigateToAddCreditCard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCreditCardScreen(),
      ),
    );
  }

  /// Navigate to edit credit card screen
  void _navigateToEditCreditCard(String cardId) {
    // TODO: Implement edit credit card navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit credit card $cardId - Coming Soon')),
    );
  }

  /// Navigate to credit card details screen
  void _navigateToCreditCardDetails(String cardId) {
    // TODO: Implement credit card details navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Credit card details $cardId - Coming Soon')),
    );
  }

  /// Navigate to make payment screen
  void _navigateToMakePayment() {
    // TODO: Implement make payment navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Make Payment - Coming Soon')),
    );
  }

  /// Navigate to credit card analytics screen
  void _navigateToCreditCardAnalytics() {
    // TODO: Implement credit card analytics navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Credit Card Analytics - Coming Soon')),
    );
  }

  /// Navigate to card settings screen
  void _navigateToCardSettings() {
    // TODO: Implement card settings navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card Settings - Coming Soon')),
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
  void _showDeleteConfirmation(String cardId, String cardName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Credit Card'),
        content: Text('Are you sure you want to delete $cardName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCreditCard(cardId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Delete credit card
  void _deleteCreditCard(String cardId) {
    // TODO: Implement delete credit card logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Delete credit card $cardId - Coming Soon')),
    );
  }
}
