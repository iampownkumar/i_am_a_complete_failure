// File: lib/core/services/database/database_service.dart
// Purpose: Database service for managing SQLite operations and data persistence

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../errors/exceptions/app_exceptions.dart' as app_exceptions;
import '../../../shared/models/transaction.dart' as transaction_model;
import '../../../shared/models/account.dart' as account_model;
import '../../../shared/models/credit_card.dart' as credit_card_model;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;
  
  DatabaseService._internal();
  
  Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<void> initialize() async {
    await database;
  }
  
  Future<Database> _initDatabase() async {
    try {
      final String path = join(await getDatabasesPath(), 'kora_expense_tracker.db');
      
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to initialize database: $e',
        originalError: e,
      );
    }
  }
  
  Future<void> _onCreate(Database db, int version) async {
    try {
      // Create transactions table
      await db.execute('''
        CREATE TABLE transactions (
          id TEXT PRIMARY KEY,
          type TEXT NOT NULL,
          amount REAL NOT NULL,
          description TEXT NOT NULL,
          category TEXT NOT NULL,
          sub_category TEXT,
          date TEXT NOT NULL,
          account_id TEXT,
          credit_card_id TEXT,
          transfer_to_account_id TEXT,
          tags TEXT,
          notes TEXT,
          currency TEXT NOT NULL,
          status TEXT NOT NULL,
          recurring_type TEXT NOT NULL,
          recurring_id TEXT,
          sms_id TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (account_id) REFERENCES accounts (id),
          FOREIGN KEY (credit_card_id) REFERENCES credit_cards (id),
          FOREIGN KEY (transfer_to_account_id) REFERENCES accounts (id)
        )
      ''');
      
      // Create accounts table
      await db.execute('''
        CREATE TABLE accounts (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          type TEXT NOT NULL,
          bank_name TEXT,
          account_number TEXT,
          routing_number TEXT,
          ifsc_code TEXT,
          balance REAL NOT NULL,
          currency TEXT NOT NULL,
          description TEXT,
          is_active INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
      
      // Create credit_cards table
      await db.execute('''
        CREATE TABLE credit_cards (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          card_number TEXT NOT NULL,
          expiry_date TEXT NOT NULL,
          cvv TEXT NOT NULL,
          type TEXT NOT NULL,
          bank_name TEXT,
          credit_limit REAL NOT NULL,
          available_credit REAL NOT NULL,
          outstanding_balance REAL NOT NULL,
          minimum_payment REAL NOT NULL,
          due_date TEXT NOT NULL,
          apr REAL NOT NULL,
          currency TEXT NOT NULL,
          description TEXT,
          is_active INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
      
      // Create categories table
      await db.execute('''
        CREATE TABLE categories (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          type TEXT NOT NULL,
          parent_id TEXT,
          icon TEXT,
          color TEXT,
          is_active INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (parent_id) REFERENCES categories (id)
        )
      ''');
      
      // Create settings table
      await db.execute('''
        CREATE TABLE settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
      
      // Insert default categories
      await _insertDefaultCategories(db);
      
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to create database tables: $e',
        originalError: e,
      );
    }
  }
  
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
  }
  
  Future<void> _insertDefaultCategories(Database db) async {
    final now = DateTime.now().toIso8601String();
    
    final categories = [
      // Income Categories
      {'id': 'income_salary', 'name': 'Salary', 'type': 'income', 'parent_id': null, 'icon': 'work', 'color': '#10B981'},
      {'id': 'income_freelance', 'name': 'Freelance', 'type': 'income', 'parent_id': null, 'icon': 'laptop', 'color': '#3B82F6'},
      {'id': 'income_investment', 'name': 'Investment', 'type': 'income', 'parent_id': null, 'icon': 'trending_up', 'color': '#8B5CF6'},
      {'id': 'income_bonus', 'name': 'Bonus', 'type': 'income', 'parent_id': null, 'icon': 'gift', 'color': '#F59E0B'},
      {'id': 'income_refund', 'name': 'Refund', 'type': 'income', 'parent_id': null, 'icon': 'undo', 'color': '#06B6D4'},
      
      // Expense Categories
      {'id': 'expense_food', 'name': 'Food & Dining', 'type': 'expense', 'parent_id': null, 'icon': 'restaurant', 'color': '#EF4444'},
      {'id': 'expense_transport', 'name': 'Transportation', 'type': 'expense', 'parent_id': null, 'icon': 'directions_car', 'color': '#F59E0B'},
      {'id': 'expense_shopping', 'name': 'Shopping', 'type': 'expense', 'parent_id': null, 'icon': 'shopping_bag', 'color': '#8B5CF6'},
      {'id': 'expense_entertainment', 'name': 'Entertainment', 'type': 'expense', 'parent_id': null, 'icon': 'movie', 'color': '#06B6D4'},
      {'id': 'expense_bills', 'name': 'Bills & Utilities', 'type': 'expense', 'parent_id': null, 'icon': 'receipt', 'color': '#84CC16'},
      {'id': 'expense_healthcare', 'name': 'Healthcare', 'type': 'expense', 'parent_id': null, 'icon': 'local_hospital', 'color': '#EF4444'},
      {'id': 'expense_education', 'name': 'Education', 'type': 'expense', 'parent_id': null, 'icon': 'school', 'color': '#3B82F6'},
      {'id': 'expense_travel', 'name': 'Travel', 'type': 'expense', 'parent_id': null, 'icon': 'flight', 'color': '#10B981'},
    ];
    
    for (final category in categories) {
      await db.insert('categories', {
        ...category,
        'is_active': 1,
        'created_at': now,
        'updated_at': now,
      });
    }
  }
  
  // Transaction CRUD operations
  Future<String> insertTransaction(transaction_model.Transaction transaction) async {
    try {
      final db = await database;
      await db.insert('transactions', transaction.toJson());
      return transaction.id;
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to insert transaction: $e',
        originalError: e,
      );
    }
  }
  
  Future<List<transaction_model.Transaction>> getTransactions({
    int? limit,
    int? offset,
    String? accountId,
    String? creditCardId,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final db = await database;
      String query = 'SELECT * FROM transactions WHERE 1=1';
      List<dynamic> args = [];
      
      if (accountId != null) {
        query += ' AND account_id = ?';
        args.add(accountId);
      }
      
      if (creditCardId != null) {
        query += ' AND credit_card_id = ?';
        args.add(creditCardId);
      }
      
      if (category != null) {
        query += ' AND category = ?';
        args.add(category);
      }
      
      if (startDate != null) {
        query += ' AND date >= ?';
        args.add(startDate.toIso8601String());
      }
      
      if (endDate != null) {
        query += ' AND date <= ?';
        args.add(endDate.toIso8601String());
      }
      
      query += ' ORDER BY date DESC';
      
      if (limit != null) {
        query += ' LIMIT ?';
        args.add(limit);
      }
      
      if (offset != null) {
        query += ' OFFSET ?';
        args.add(offset);
      }
      
      final List<Map<String, dynamic>> maps = await db.rawQuery(query, args);
      return maps.map((map) => transaction_model.Transaction.fromJson(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to get transactions: $e',
        originalError: e,
      );
    }
  }
  
  Future<transaction_model.Transaction?> getTransaction(String id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (maps.isNotEmpty) {
        return transaction_model.Transaction.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to get transaction: $e',
        originalError: e,
      );
    }
  }
  
  Future<void> updateTransaction(transaction_model.Transaction transaction) async {
    try {
      final db = await database;
      await db.update(
        'transactions',
        transaction.toJson(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to update transaction: $e',
        originalError: e,
      );
    }
  }
  
  Future<void> deleteTransaction(String id) async {
    try {
      final db = await database;
      await db.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to delete transaction: $e',
        originalError: e,
      );
    }
  }
  
  // Account CRUD operations
  Future<String> insertAccount(account_model.Account account) async {
    try {
      final db = await database;
      await db.insert('accounts', account.toJson());
      return account.id;
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to insert account: $e',
        originalError: e,
      );
    }
  }
  
  Future<List<account_model.Account>> getAccounts() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'accounts',
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => account_model.Account.fromJson(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to get accounts: $e',
        originalError: e,
      );
    }
  }
  
  Future<account_model.Account?> getAccount(String id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'accounts',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (maps.isNotEmpty) {
        return account_model.Account.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to get account: $e',
        originalError: e,
      );
    }
  }
  
  Future<void> updateAccount(account_model.Account account) async {
    try {
      final db = await database;
      await db.update(
        'accounts',
        account.toJson(),
        where: 'id = ?',
        whereArgs: [account.id],
      );
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to update account: $e',
        originalError: e,
      );
    }
  }
  
  Future<void> deleteAccount(String id) async {
    try {
      final db = await database;
      await db.delete(
        'accounts',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to delete account: $e',
        originalError: e,
      );
    }
  }
  
  // Credit Card CRUD operations
  Future<String> insertCreditCard(credit_card_model.CreditCard creditCard) async {
    try {
      final db = await database;
      await db.insert('credit_cards', creditCard.toJson());
      return creditCard.id;
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to insert credit card: $e',
        originalError: e,
      );
    }
  }
  
  Future<List<credit_card_model.CreditCard>> getCreditCards() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'credit_cards',
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => credit_card_model.CreditCard.fromJson(map)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to get credit cards: $e',
        originalError: e,
      );
    }
  }
  
  Future<credit_card_model.CreditCard?> getCreditCard(String id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'credit_cards',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (maps.isNotEmpty) {
        return credit_card_model.CreditCard.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to get credit card: $e',
        originalError: e,
      );
    }
  }
  
  Future<void> updateCreditCard(credit_card_model.CreditCard creditCard) async {
    try {
      final db = await database;
      await db.update(
        'credit_cards',
        creditCard.toJson(),
        where: 'id = ?',
        whereArgs: [creditCard.id],
      );
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to update credit card: $e',
        originalError: e,
      );
    }
  }
  
  Future<void> deleteCreditCard(String id) async {
    try {
      final db = await database;
      await db.delete(
        'credit_cards',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to delete credit card: $e',
        originalError: e,
      );
    }
  }
  
  // Settings operations
  Future<void> setSetting(String key, String value) async {
    try {
      final db = await database;
      await db.insert(
        'settings',
        {
          'key': key,
          'value': value,
          'updated_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to set setting: $e',
        originalError: e,
      );
    }
  }
  
  Future<String?> getSetting(String key) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'settings',
        where: 'key = ?',
        whereArgs: [key],
      );
      
      if (maps.isNotEmpty) {
        return maps.first['value'] as String;
      }
      return null;
    } catch (e) {
      throw app_exceptions.DatabaseException(
        message: 'Failed to get setting: $e',
        originalError: e,
      );
    }
  }
  
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
