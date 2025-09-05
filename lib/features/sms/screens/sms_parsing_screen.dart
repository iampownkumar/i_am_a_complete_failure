import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/sms/sms_parser_service.dart';
import '../../../core/constants/enums/app_enums.dart';
import '../widgets/parsed_transaction_card.dart';
import '../widgets/sms_pattern_list_tile.dart';

/// SMS Parsing Screen
/// Location: lib/features/sms/screens/sms_parsing_screen.dart
/// Purpose: Manage SMS parsing, view parsed transactions, and configure patterns
class SmsParsingScreen extends StatefulWidget {
  const SmsParsingScreen({super.key});

  @override
  State<SmsParsingScreen> createState() => _SmsParsingScreenState();
}

class _SmsParsingScreenState extends State<SmsParsingScreen> {
  final SmsParserService _smsParserService = SmsParserService();
  final TextEditingController _smsController = TextEditingController();
  
  List<ParsedTransaction> _parsedTransactions = [];
  List<SmsPattern> _patterns = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Parsing'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSmsSettings,
            tooltip: 'SMS Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SMS Input Section
            _buildSmsInputSection(),
            
            const SizedBox(height: 24),
            
            // Parsing Statistics
            _buildStatsSection(),
            
            const SizedBox(height: 24),
            
            // Parsed Transactions
            _buildParsedTransactionsSection(),
            
            const SizedBox(height: 24),
            
            // SMS Patterns
            _buildPatternsSection(),
          ],
        ),
      ),
    );
  }

  /// Build SMS input section
  Widget _buildSmsInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test SMS Parsing',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _smsController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Paste SMS content here',
                hintText: 'Example: Rs. 1000.00 debited from your account on 15-01-2024. Avl Bal Rs. 5000.00',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _parseSms,
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.analytics),
                    label: Text(_isLoading ? 'Parsing...' : 'Parse SMS'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _clearInput,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ],
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build statistics section
  Widget _buildStatsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parsing Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Parsed',
                    '${_stats['totalParsed'] ?? 0}',
                    Icons.sms,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Successful',
                    '${_stats['totalSuccessful'] ?? 0}',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Failed',
                    '${_stats['totalFailed'] ?? 0}',
                    Icons.error,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Success Rate',
                    '${((_stats['successRate'] ?? 0.0) * 100).toStringAsFixed(1)}%',
                    Icons.trending_up,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Patterns',
                    '${_stats['patternsCount'] ?? 0}',
                    Icons.pattern,
                    Colors.purple,
                  ),
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearStats,
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('Clear Stats'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build parsed transactions section
  Widget _buildParsedTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Parsed Transactions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_parsedTransactions.isNotEmpty)
              TextButton.icon(
                onPressed: _clearParsedTransactions,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear All'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_parsedTransactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.sms_failed,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No Parsed Transactions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Parse an SMS to see transactions here',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _parsedTransactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final transaction = _parsedTransactions[index];
              return ParsedTransactionCard(
                transaction: transaction,
                onApprove: () => _approveTransaction(transaction),
                onReject: () => _rejectTransaction(transaction),
                onEdit: () => _editTransaction(transaction),
              );
            },
          ),
      ],
    );
  }

  /// Build patterns section
  Widget _buildPatternsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SMS Patterns',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _navigateToAddPattern,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Pattern'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _patterns.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final pattern = _patterns[index];
            return SmsPatternListTile(
              pattern: pattern,
              onEdit: () => _editPattern(pattern),
              onDelete: () => _deletePattern(pattern),
              onTest: () => _testPattern(pattern),
            );
          },
        ),
      ],
    );
  }

  /// Build individual stat item
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Load data
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _smsParserService.initialize();
      final patterns = _smsParserService.getAllPatterns();
      final stats = await _smsParserService.getParsingStats();
      
      setState(() {
        _patterns = patterns;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  /// Parse SMS
  Future<void> _parseSms() async {
    final smsBody = _smsController.text.trim();
    if (smsBody.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter SMS content';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final parsedTransaction = await _smsParserService.parseSms(smsBody, 'Test Sender');
      
      if (parsedTransaction != null) {
        setState(() {
          _parsedTransactions.insert(0, parsedTransaction);
          _isLoading = false;
        });
        
        // Update stats
        await _updateStats(true);
        await _loadData(); // Reload stats
      } else {
        setState(() {
          _errorMessage = 'No transaction pattern matched this SMS';
          _isLoading = false;
        });
        
        // Update stats
        await _updateStats(false);
        await _loadData(); // Reload stats
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to parse SMS: $e';
        _isLoading = false;
      });
      
      // Update stats
      await _updateStats(false);
      await _loadData(); // Reload stats
    }
  }

  /// Clear input
  void _clearInput() {
    _smsController.clear();
    setState(() {
      _errorMessage = '';
    });
  }

  /// Clear parsed transactions
  void _clearParsedTransactions() {
    setState(() {
      _parsedTransactions.clear();
    });
  }

  /// Clear statistics
  Future<void> _clearStats() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Statistics'),
        content: const Text('Are you sure you want to clear all parsing statistics?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await _smsParserService.clearStats();
      await _loadData();
    }
  }

  /// Approve transaction
  void _approveTransaction(ParsedTransaction transaction) {
    // TODO: Implement approve transaction
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Approve Transaction - Coming Soon')),
    );
  }

  /// Reject transaction
  void _rejectTransaction(ParsedTransaction transaction) {
    setState(() {
      _parsedTransactions.remove(transaction);
    });
  }

  /// Edit transaction
  void _editTransaction(ParsedTransaction transaction) {
    // TODO: Implement edit transaction
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Transaction - Coming Soon')),
    );
  }

  /// Navigate to SMS settings
  void _navigateToSmsSettings() {
    // TODO: Implement SMS settings navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SMS Settings - Coming Soon')),
    );
  }

  /// Navigate to add pattern
  void _navigateToAddPattern() {
    // TODO: Implement add pattern navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Pattern - Coming Soon')),
    );
  }

  /// Edit pattern
  void _editPattern(SmsPattern pattern) {
    // TODO: Implement edit pattern
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Pattern - Coming Soon')),
    );
  }

  /// Delete pattern
  Future<void> _deletePattern(SmsPattern pattern) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pattern'),
        content: Text('Are you sure you want to delete the pattern for ${pattern.bankName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await _smsParserService.removePattern(pattern.id);
      await _loadData();
    }
  }

  /// Test pattern
  void _testPattern(SmsPattern pattern) {
    // TODO: Implement test pattern
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test Pattern - Coming Soon')),
    );
  }

  /// Update parsing statistics
  Future<void> _updateStats(bool success) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final totalParsed = (prefs.getInt('sms_total_parsed') ?? 0) + 1;
      final totalSuccessful = (prefs.getInt('sms_total_successful') ?? 0) + (success ? 1 : 0);
      final totalFailed = (prefs.getInt('sms_total_failed') ?? 0) + (success ? 0 : 1);
      
      await prefs.setInt('sms_total_parsed', totalParsed);
      await prefs.setInt('sms_total_successful', totalSuccessful);
      await prefs.setInt('sms_total_failed', totalFailed);
    } catch (e) {
      print('Failed to update parsing stats: $e');
    }
  }
}
