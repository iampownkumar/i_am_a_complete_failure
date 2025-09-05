import 'package:flutter/material.dart';
import '../../../core/services/sms/sms_parser_service.dart';
import '../../../core/constants/enums/app_enums.dart';

/// SMS Pattern List Tile Widget
/// Location: lib/features/sms/widgets/sms_pattern_list_tile.dart
/// Purpose: Display SMS pattern information in a list
class SmsPatternListTile extends StatelessWidget {
  final SmsPattern pattern;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTest;

  const SmsPatternListTile({
    super.key,
    required this.pattern,
    this.onEdit,
    this.onDelete,
    this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Bank Icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getBankColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.account_balance,
                    color: _getBankColor(),
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Bank Name and Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pattern.bankName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pattern.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Transaction Type Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getTransactionTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getTransactionTypeColor().withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    pattern.transactionType.name.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getTransactionTypeColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Pattern Preview
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pattern',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pattern.pattern,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Group Information
            Row(
              children: [
                _buildGroupInfo('Amount', pattern.amountGroup),
                const SizedBox(width: 16),
                _buildGroupInfo('Date', pattern.dateGroup),
                const SizedBox(width: 16),
                _buildGroupInfo('Balance', pattern.balanceGroup),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTest,
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('Test'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build group information
  Widget _buildGroupInfo(String label, int groupNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Group $groupNumber',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[700],
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  /// Get bank color based on bank name
  Color _getBankColor() {
    switch (pattern.bankName.toLowerCase()) {
      case 'hdfc bank':
        return Colors.blue;
      case 'state bank of india':
        return Colors.orange;
      case 'icici bank':
        return Colors.purple;
      case 'axis bank':
        return Colors.red;
      case 'credit card':
        return Colors.green;
      case 'upi':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  /// Get transaction type color
  Color _getTransactionTypeColor() {
    switch (pattern.transactionType) {
      case TransactionType.income:
        return Colors.green;
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.transfer:
        return Colors.blue;
      case TransactionType.investment:
        return Colors.purple;
    }
  }
}
