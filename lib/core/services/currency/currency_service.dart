import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../errors/exceptions/app_exceptions.dart';

/// Currency Service
/// Location: lib/core/services/currency/currency_service.dart
/// Purpose: Handle currency conversion, exchange rates, and multi-currency support
class CurrencyService {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';
  static const String _cacheKey = 'currency_rates_cache';
  static const String _lastUpdateKey = 'currency_rates_last_update';
  static const Duration _cacheExpiry = Duration(hours: 1);

  final Dio _dio = Dio();
  Map<String, double> _exchangeRates = {};
  String _baseCurrency = 'INR';
  DateTime? _lastUpdate;

  /// Initialize the currency service
  Future<void> initialize() async {
    await _loadCachedRates();
    await _updateExchangeRates();
  }

  /// Get exchange rate between two currencies
  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    if (fromCurrency == toCurrency) return 1.0;

    // Check if we need to update rates
    if (_shouldUpdateRates()) {
      await _updateExchangeRates();
    }

    // If base currency is not the from currency, convert through base
    if (fromCurrency != _baseCurrency) {
      final fromToBase = _exchangeRates[fromCurrency] ?? 1.0;
      final baseToTo = _exchangeRates[toCurrency] ?? 1.0;
      return baseToTo / fromToBase;
    }

    return _exchangeRates[toCurrency] ?? 1.0;
  }

  /// Convert amount from one currency to another
  Future<double> convertAmount(
    double amount,
    String fromCurrency,
    String toCurrency,
  ) async {
    final rate = await getExchangeRate(fromCurrency, toCurrency);
    return amount * rate;
  }

  /// Get all supported currencies
  List<String> getSupportedCurrencies() {
    return [
      'INR', // Indian Rupee (Default)
      'USD', // US Dollar
      'EUR', // Euro
      'GBP', // British Pound
      'JPY', // Japanese Yen
      'CAD', // Canadian Dollar
      'AUD', // Australian Dollar
      'CHF', // Swiss Franc
      'CNY', // Chinese Yuan
      'SGD', // Singapore Dollar
      'AED', // UAE Dirham
      'SAR', // Saudi Riyal
      'BRL', // Brazilian Real
      'MXN', // Mexican Peso
      'RUB', // Russian Ruble
      'ZAR', // South African Rand
      'KRW', // South Korean Won
      'THB', // Thai Baht
      'MYR', // Malaysian Ringgit
      'IDR', // Indonesian Rupiah
    ];
  }

  /// Get currency symbol
  String getCurrencySymbol(String currency) {
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
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      case 'CHF':
        return 'CHF';
      case 'CNY':
        return '¥';
      case 'SGD':
        return 'S\$';
      case 'AED':
        return 'د.إ';
      case 'SAR':
        return 'ر.س';
      case 'BRL':
        return 'R\$';
      case 'MXN':
        return '\$';
      case 'RUB':
        return '₽';
      case 'ZAR':
        return 'R';
      case 'KRW':
        return '₩';
      case 'THB':
        return '฿';
      case 'MYR':
        return 'RM';
      case 'IDR':
        return 'Rp';
      default:
        return currency;
    }
  }

  /// Get currency name
  String getCurrencyName(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return 'Indian Rupee';
      case 'USD':
        return 'US Dollar';
      case 'EUR':
        return 'Euro';
      case 'GBP':
        return 'British Pound';
      case 'JPY':
        return 'Japanese Yen';
      case 'CAD':
        return 'Canadian Dollar';
      case 'AUD':
        return 'Australian Dollar';
      case 'CHF':
        return 'Swiss Franc';
      case 'CNY':
        return 'Chinese Yuan';
      case 'SGD':
        return 'Singapore Dollar';
      case 'AED':
        return 'UAE Dirham';
      case 'SAR':
        return 'Saudi Riyal';
      case 'BRL':
        return 'Brazilian Real';
      case 'MXN':
        return 'Mexican Peso';
      case 'RUB':
        return 'Russian Ruble';
      case 'ZAR':
        return 'South African Rand';
      case 'KRW':
        return 'South Korean Won';
      case 'THB':
        return 'Thai Baht';
      case 'MYR':
        return 'Malaysian Ringgit';
      case 'IDR':
        return 'Indonesian Rupiah';
      default:
        return currency;
    }
  }

  /// Format amount with currency
  String formatAmount(double amount, String currency, {int decimalDigits = 2}) {
    final symbol = getCurrencySymbol(currency);
    final formattedAmount = amount.toStringAsFixed(decimalDigits);
    return '$symbol$formattedAmount';
  }

  /// Get default currency
  String getDefaultCurrency() => _baseCurrency;

  /// Set default currency
  Future<void> setDefaultCurrency(String currency) async {
    if (getSupportedCurrencies().contains(currency.toUpperCase())) {
      _baseCurrency = currency.toUpperCase();
      await _saveDefaultCurrency();
    }
  }

  /// Get all exchange rates
  Map<String, double> getAllExchangeRates() => Map.from(_exchangeRates);

  /// Force update exchange rates
  Future<void> forceUpdateRates() async {
    await _updateExchangeRates();
  }

  /// Check if rates should be updated
  bool _shouldUpdateRates() {
    if (_lastUpdate == null) return true;
    return DateTime.now().difference(_lastUpdate!) > _cacheExpiry;
  }

  /// Update exchange rates from API
  Future<void> _updateExchangeRates() async {
    try {
      final response = await _dio.get('$_baseUrl/$_baseCurrency');
      
      if (response.statusCode == 200) {
        final data = response.data;
        _exchangeRates = Map<String, double>.from(data['rates']);
        _lastUpdate = DateTime.now();
        
        // Cache the rates
        await _cacheRates();
      } else {
        throw NetworkException(message: 'Failed to fetch exchange rates: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException(message: 'Connection timeout while fetching exchange rates');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(message: 'No internet connection');
      } else {
        throw NetworkException(message: 'Failed to fetch exchange rates: ${e.message}');
      }
    } catch (e) {
      throw NetworkException(message: 'Unexpected error while fetching exchange rates: $e');
    }
  }

  /// Cache exchange rates
  Future<void> _cacheRates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(_exchangeRates));
      await prefs.setString(_lastUpdateKey, _lastUpdate!.toIso8601String());
    } catch (e) {
      // Cache failure is not critical, just log it
      print('Failed to cache exchange rates: $e');
    }
  }

  /// Load cached exchange rates
  Future<void> _loadCachedRates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedRates = prefs.getString(_cacheKey);
      final lastUpdateString = prefs.getString(_lastUpdateKey);
      
      if (cachedRates != null && lastUpdateString != null) {
        _exchangeRates = Map<String, double>.from(jsonDecode(cachedRates));
        _lastUpdate = DateTime.parse(lastUpdateString);
      }
    } catch (e) {
      // Cache loading failure is not critical, just log it
      print('Failed to load cached exchange rates: $e');
    }
  }

  /// Save default currency
  Future<void> _saveDefaultCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('default_currency', _baseCurrency);
    } catch (e) {
      print('Failed to save default currency: $e');
    }
  }

  /// Load default currency
  Future<void> _loadDefaultCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCurrency = prefs.getString('default_currency');
      if (savedCurrency != null && getSupportedCurrencies().contains(savedCurrency)) {
        _baseCurrency = savedCurrency;
      }
    } catch (e) {
      print('Failed to load default currency: $e');
    }
  }

  /// Get currency conversion history
  Future<List<Map<String, dynamic>>> getConversionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('conversion_history');
      if (historyJson != null) {
        final List<dynamic> history = jsonDecode(historyJson);
        return history.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Failed to load conversion history: $e');
    }
    return [];
  }

  /// Save currency conversion to history
  Future<void> saveConversionToHistory({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
    required double convertedAmount,
    required double rate,
  }) async {
    try {
      final history = await getConversionHistory();
      final conversion = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'amount': amount,
        'fromCurrency': fromCurrency,
        'toCurrency': toCurrency,
        'convertedAmount': convertedAmount,
        'rate': rate,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      history.insert(0, conversion);
      
      // Keep only last 100 conversions
      if (history.length > 100) {
        history.removeRange(100, history.length);
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('conversion_history', jsonEncode(history));
    } catch (e) {
      print('Failed to save conversion to history: $e');
    }
  }

  /// Clear conversion history
  Future<void> clearConversionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('conversion_history');
    } catch (e) {
      print('Failed to clear conversion history: $e');
    }
  }
}
