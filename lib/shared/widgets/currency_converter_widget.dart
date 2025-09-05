import 'package:flutter/material.dart';
import '../../core/services/currency/currency_service.dart';

/// Currency Converter Widget
/// Location: lib/shared/widgets/currency_converter_widget.dart
/// Purpose: Reusable widget for currency conversion with real-time rates
class CurrencyConverterWidget extends StatefulWidget {
  final double initialAmount;
  final String initialFromCurrency;
  final String initialToCurrency;
  final Function(double convertedAmount, double rate)? onConversionChanged;
  final bool showHistory;
  final bool readOnly;

  const CurrencyConverterWidget({
    super.key,
    this.initialAmount = 0.0,
    this.initialFromCurrency = 'INR',
    this.initialToCurrency = 'USD',
    this.onConversionChanged,
    this.showHistory = false,
    this.readOnly = false,
  });

  @override
  State<CurrencyConverterWidget> createState() => _CurrencyConverterWidgetState();
}

class _CurrencyConverterWidgetState extends State<CurrencyConverterWidget> {
  final CurrencyService _currencyService = CurrencyService();
  final TextEditingController _amountController = TextEditingController();
  
  String _fromCurrency = 'INR';
  String _toCurrency = 'USD';
  double _convertedAmount = 0.0;
  double _exchangeRate = 1.0;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fromCurrency = widget.initialFromCurrency;
    _toCurrency = widget.initialToCurrency;
    _amountController.text = widget.initialAmount.toString();
    _convertCurrency();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.currency_exchange,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Currency Converter',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Amount Input
            TextFormField(
              controller: _amountController,
              enabled: !widget.readOnly,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.attach_money),
                border: const OutlineInputBorder(),
                suffixText: _currencyService.getCurrencySymbol(_fromCurrency),
              ),
              onChanged: (value) {
                if (!widget.readOnly) {
                  _convertCurrency();
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Currency Selection Row
            Row(
              children: [
                // From Currency
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _fromCurrency,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: _currencyService.getSupportedCurrencies().map((currency) {
                          return DropdownMenuItem(
                            value: currency,
                            child: Text('$currency - ${_currencyService.getCurrencyName(currency)}'),
                          );
                        }).toList(),
                        onChanged: widget.readOnly ? null : (value) {
                          if (value != null) {
                            setState(() {
                              _fromCurrency = value;
                            });
                            _convertCurrency();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Swap Button
                IconButton(
                  onPressed: widget.readOnly ? null : _swapCurrencies,
                  icon: Icon(
                    Icons.swap_horiz,
                    color: Theme.of(context).primaryColor,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // To Currency
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _toCurrency,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: _currencyService.getSupportedCurrencies().map((currency) {
                          return DropdownMenuItem(
                            value: currency,
                            child: Text('$currency - ${_currencyService.getCurrencyName(currency)}'),
                          );
                        }).toList(),
                        onChanged: widget.readOnly ? null : (value) {
                          if (value != null) {
                            setState(() {
                              _toCurrency = value;
                            });
                            _convertCurrency();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Conversion Result
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage.isNotEmpty)
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
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Converted Amount',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currencyService.formatAmount(_convertedAmount, _toCurrency),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Exchange Rate: 1 $_fromCurrency = ${_exchangeRate.toStringAsFixed(4)} $_toCurrency',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            
            // History Section
            if (widget.showHistory) ...[
              const SizedBox(height: 16),
              _buildHistorySection(),
            ],
          ],
        ),
      ),
    );
  }

  /// Build history section
  Widget _buildHistorySection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _currencyService.getConversionHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final history = snapshot.data ?? [];
        
        if (history.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'No conversion history available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Conversions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _clearHistory,
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final conversion = history[index];
                  return ListTile(
                    leading: Icon(
                      Icons.currency_exchange,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      '${conversion['amount']} ${conversion['fromCurrency']} → ${conversion['convertedAmount']} ${conversion['toCurrency']}',
                    ),
                    subtitle: Text(
                      'Rate: ${conversion['rate'].toStringAsFixed(4)} • ${_formatTimestamp(conversion['timestamp'])}',
                    ),
                    dense: true,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Convert currency
  Future<void> _convertCurrency() async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    
    if (amount <= 0) {
      setState(() {
        _convertedAmount = 0.0;
        _exchangeRate = 1.0;
        _errorMessage = '';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final rate = await _currencyService.getExchangeRate(_fromCurrency, _toCurrency);
      final convertedAmount = await _currencyService.convertAmount(amount, _fromCurrency, _toCurrency);
      
      setState(() {
        _convertedAmount = convertedAmount;
        _exchangeRate = rate;
        _isLoading = false;
      });
      
      // Save to history
      await _currencyService.saveConversionToHistory(
        amount: amount,
        fromCurrency: _fromCurrency,
        toCurrency: _toCurrency,
        convertedAmount: convertedAmount,
        rate: rate,
      );
      
      // Notify parent widget
      widget.onConversionChanged?.call(convertedAmount, rate);
      
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Swap currencies
  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _convertCurrency();
  }

  /// Clear conversion history
  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all conversion history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _currencyService.clearConversionHistory();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Format timestamp
  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
