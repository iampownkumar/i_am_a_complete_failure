import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../errors/exceptions/app_exceptions.dart';
import '../../constants/enums/app_enums.dart';

/// SMS Parser Service
/// Location: lib/core/services/sms/sms_parser_service.dart
/// Purpose: Parse SMS messages to extract transaction data automatically
class SmsParserService {
  static final SmsParserService _instance = SmsParserService._internal();
  factory SmsParserService() => _instance;
  SmsParserService._internal();

  bool _isInitialized = false;
  List<SmsPattern> _patterns = [];

  /// Initialize the SMS parser service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request SMS permission
      await _requestSmsPermission();
      
      // Load SMS patterns
      await _loadSmsPatterns();
      
      _isInitialized = true;
    } catch (e) {
      throw SmsException(message: 'Failed to initialize SMS parser: $e');
    }
  }

  /// Request SMS permission
  Future<bool> _requestSmsPermission() async {
    try {
      final status = await Permission.sms.request();
      return status.isGranted;
    } catch (e) {
      throw PermissionException(message: 'Failed to request SMS permission: $e');
    }
  }

  /// Load SMS patterns from storage
  Future<void> _loadSmsPatterns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final patternsJson = prefs.getString('sms_patterns');
      
      if (patternsJson != null) {
        final List<dynamic> patterns = jsonDecode(patternsJson);
        _patterns = patterns.map((pattern) => SmsPattern.fromJson(pattern)).toList();
      } else {
        // Load default patterns
        _patterns = _getDefaultPatterns();
        await _saveSmsPatterns();
      }
    } catch (e) {
      // If loading fails, use default patterns
      _patterns = _getDefaultPatterns();
    }
  }

  /// Save SMS patterns to storage
  Future<void> _saveSmsPatterns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final patternsJson = jsonEncode(_patterns.map((pattern) => pattern.toJson()).toList());
      await prefs.setString('sms_patterns', patternsJson);
    } catch (e) {
      print('Failed to save SMS patterns: $e');
    }
  }

  /// Get default SMS patterns for Indian banks
  List<SmsPattern> _getDefaultPatterns() {
    return [
      // HDFC Bank patterns
      SmsPattern(
        id: 'hdfc_debit',
        bankName: 'HDFC Bank',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*debited.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Bal\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.expense,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'HDFC Debit Transaction',
      ),
      SmsPattern(
        id: 'hdfc_credit',
        bankName: 'HDFC Bank',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*credited.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Bal\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.income,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'HDFC Credit Transaction',
      ),
      
      // SBI patterns
      SmsPattern(
        id: 'sbi_debit',
        bankName: 'State Bank of India',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*debited.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Bal\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.expense,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'SBI Debit Transaction',
      ),
      SmsPattern(
        id: 'sbi_credit',
        bankName: 'State Bank of India',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*credited.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Bal\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.income,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'SBI Credit Transaction',
      ),
      
      // ICICI Bank patterns
      SmsPattern(
        id: 'icici_debit',
        bankName: 'ICICI Bank',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*debited.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Bal\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.expense,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'ICICI Debit Transaction',
      ),
      SmsPattern(
        id: 'icici_credit',
        bankName: 'ICICI Bank',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*credited.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Bal\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.income,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'ICICI Credit Transaction',
      ),
      
      // Axis Bank patterns
      SmsPattern(
        id: 'axis_debit',
        bankName: 'Axis Bank',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*debited.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Bal\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.expense,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'Axis Debit Transaction',
      ),
      SmsPattern(
        id: 'axis_credit',
        bankName: 'Axis Bank',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*credited.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Bal\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.income,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'Axis Credit Transaction',
      ),
      
      // Credit Card patterns
      SmsPattern(
        id: 'credit_card_payment',
        bankName: 'Credit Card',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*spent.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Lmt\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.expense,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'Credit Card Payment',
      ),
      
      // UPI patterns
      SmsPattern(
        id: 'upi_debit',
        bankName: 'UPI',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*paid.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Bal\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.expense,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'UPI Payment',
      ),
      SmsPattern(
        id: 'upi_credit',
        bankName: 'UPI',
        pattern: r'Rs\.?\s*(\d+(?:\.\d{2})?)\s*received.*?on\s*(\d{2}-\d{2}-\d{4}).*?Avl\s*Bal\s*Rs\.?\s*(\d+(?:\.\d{2})?)',
        transactionType: TransactionType.income,
        amountGroup: 1,
        dateGroup: 2,
        balanceGroup: 3,
        description: 'UPI Receipt',
      ),
    ];
  }

  /// Parse SMS message to extract transaction data
  Future<ParsedTransaction?> parseSms(String smsBody, String sender) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      for (final pattern in _patterns) {
        final regex = RegExp(pattern.pattern, caseSensitive: false);
        final match = regex.firstMatch(smsBody);
        
        if (match != null) {
          return _extractTransactionFromMatch(match, pattern, smsBody, sender);
        }
      }
      
      return null; // No pattern matched
    } catch (e) {
      throw SmsException(message: 'Failed to parse SMS: $e');
    }
  }

  /// Extract transaction data from regex match
  ParsedTransaction _extractTransactionFromMatch(
    RegExpMatch match,
    SmsPattern pattern,
    String smsBody,
    String sender,
  ) {
    try {
      final amount = double.parse(match.group(pattern.amountGroup) ?? '0');
      final dateStr = match.group(pattern.dateGroup) ?? '';
      final balance = double.parse(match.group(pattern.balanceGroup) ?? '0');
      
      // Parse date (assuming DD-MM-YYYY format)
      DateTime? date;
      if (dateStr.isNotEmpty) {
        final dateParts = dateStr.split('-');
        if (dateParts.length == 3) {
          date = DateTime(
            int.parse(dateParts[2]), // year
            int.parse(dateParts[1]), // month
            int.parse(dateParts[0]), // day
          );
        }
      }
      
      // If date parsing failed, use current date
      date ??= DateTime.now();
      
      return ParsedTransaction(
        amount: amount,
        date: date,
        balance: balance,
        transactionType: pattern.transactionType,
        bankName: pattern.bankName,
        description: pattern.description,
        originalSms: smsBody,
        sender: sender,
        confidence: _calculateConfidence(match, pattern),
      );
    } catch (e) {
      throw SmsException(message: 'Failed to extract transaction data: $e');
    }
  }

  /// Calculate confidence score for parsed transaction
  double _calculateConfidence(RegExpMatch match, SmsPattern pattern) {
    double confidence = 0.5; // Base confidence
    
    // Increase confidence if all groups are matched
    if (match.group(pattern.amountGroup) != null) confidence += 0.2;
    if (match.group(pattern.dateGroup) != null) confidence += 0.2;
    if (match.group(pattern.balanceGroup) != null) confidence += 0.1;
    
    // Increase confidence based on pattern specificity
    if (pattern.pattern.contains(r'\d{2}-\d{2}-\d{4}')) confidence += 0.1;
    if (pattern.pattern.contains(r'Rs\.?')) confidence += 0.1;
    
    return confidence.clamp(0.0, 1.0);
  }

  /// Add custom SMS pattern
  Future<void> addCustomPattern(SmsPattern pattern) async {
    _patterns.add(pattern);
    await _saveSmsPatterns();
  }

  /// Remove SMS pattern
  Future<void> removePattern(String patternId) async {
    _patterns.removeWhere((pattern) => pattern.id == patternId);
    await _saveSmsPatterns();
  }

  /// Get all SMS patterns
  List<SmsPattern> getAllPatterns() => List.from(_patterns);

  /// Update SMS pattern
  Future<void> updatePattern(SmsPattern updatedPattern) async {
    final index = _patterns.indexWhere((pattern) => pattern.id == updatedPattern.id);
    if (index != -1) {
      _patterns[index] = updatedPattern;
      await _saveSmsPatterns();
    }
  }

  /// Test SMS pattern
  bool testPattern(String smsBody, SmsPattern pattern) {
    try {
      final regex = RegExp(pattern.pattern, caseSensitive: false);
      return regex.hasMatch(smsBody);
    } catch (e) {
      return false;
    }
  }

  /// Get parsing statistics
  Future<Map<String, dynamic>> getParsingStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final totalParsed = prefs.getInt('sms_total_parsed') ?? 0;
      final totalSuccessful = prefs.getInt('sms_total_successful') ?? 0;
      final totalFailed = prefs.getInt('sms_total_failed') ?? 0;
      
      return {
        'totalParsed': totalParsed,
        'totalSuccessful': totalSuccessful,
        'totalFailed': totalFailed,
        'successRate': totalParsed > 0 ? (totalSuccessful / totalParsed) : 0.0,
        'patternsCount': _patterns.length,
      };
    } catch (e) {
      return {
        'totalParsed': 0,
        'totalSuccessful': 0,
        'totalFailed': 0,
        'successRate': 0.0,
        'patternsCount': _patterns.length,
      };
    }
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

  /// Check if SMS permission is granted
  Future<bool> hasSmsPermission() async {
    try {
      final status = await Permission.sms.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Request SMS permission
  Future<bool> requestSmsPermission() async {
    try {
      final status = await Permission.sms.request();
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Clear parsing statistics
  Future<void> clearStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('sms_total_parsed');
      await prefs.remove('sms_total_successful');
      await prefs.remove('sms_total_failed');
    } catch (e) {
      print('Failed to clear parsing stats: $e');
    }
  }
}

/// SMS Pattern model
class SmsPattern {
  final String id;
  final String bankName;
  final String pattern;
  final TransactionType transactionType;
  final int amountGroup;
  final int dateGroup;
  final int balanceGroup;
  final String description;

  SmsPattern({
    required this.id,
    required this.bankName,
    required this.pattern,
    required this.transactionType,
    required this.amountGroup,
    required this.dateGroup,
    required this.balanceGroup,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'pattern': pattern,
      'transactionType': transactionType.name,
      'amountGroup': amountGroup,
      'dateGroup': dateGroup,
      'balanceGroup': balanceGroup,
      'description': description,
    };
  }

  factory SmsPattern.fromJson(Map<String, dynamic> json) {
    return SmsPattern(
      id: json['id'],
      bankName: json['bankName'],
      pattern: json['pattern'],
      transactionType: TransactionType.values.firstWhere(
        (e) => e.name == json['transactionType'],
        orElse: () => TransactionType.expense,
      ),
      amountGroup: json['amountGroup'],
      dateGroup: json['dateGroup'],
      balanceGroup: json['balanceGroup'],
      description: json['description'],
    );
  }
}

/// Parsed Transaction model
class ParsedTransaction {
  final double amount;
  final DateTime date;
  final double balance;
  final TransactionType transactionType;
  final String bankName;
  final String description;
  final String originalSms;
  final String sender;
  final double confidence;

  ParsedTransaction({
    required this.amount,
    required this.date,
    required this.balance,
    required this.transactionType,
    required this.bankName,
    required this.description,
    required this.originalSms,
    required this.sender,
    required this.confidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
      'balance': balance,
      'transactionType': transactionType.name,
      'bankName': bankName,
      'description': description,
      'originalSms': originalSms,
      'sender': sender,
      'confidence': confidence,
    };
  }

  factory ParsedTransaction.fromJson(Map<String, dynamic> json) {
    return ParsedTransaction(
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      balance: json['balance'].toDouble(),
      transactionType: TransactionType.values.firstWhere(
        (e) => e.name == json['transactionType'],
        orElse: () => TransactionType.expense,
      ),
      bankName: json['bankName'],
      description: json['description'],
      originalSms: json['originalSms'],
      sender: json['sender'],
      confidence: json['confidence'].toDouble(),
    );
  }
}
