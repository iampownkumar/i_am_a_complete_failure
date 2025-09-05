import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../errors/exceptions/app_exceptions.dart';

/// Notification Service
/// Location: lib/core/services/notifications/notification_service.dart
/// Purpose: Handle local notifications, reminders, and alerts
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request notification permission
      await _requestNotificationPermission();

      // Initialize Android settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // Initialize iOS settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _isInitialized = true;
    } catch (e) {
      throw NotificationException(message: 'Failed to initialize notifications: $e');
    }
  }

  /// Request notification permission
  Future<bool> _requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (e) {
      throw PermissionException(message: 'Failed to request notification permission: $e');
    }
  }

  /// Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'kora_expense_tracker',
        'Kora Expense Tracker',
        channelDescription: 'Notifications for Kora Expense Tracker',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      throw NotificationException(message: 'Failed to show notification: $e');
    }
  }

  /// Schedule notification for specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'kora_expense_tracker_scheduled',
        'Scheduled Notifications',
        channelDescription: 'Scheduled notifications for Kora Expense Tracker',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.schedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        payload: payload,
      );
    } catch (e) {
      throw NotificationException(message: 'Failed to schedule notification: $e');
    }
  }

  /// Schedule recurring notification
  Future<void> scheduleRecurringNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required List<int> days, // 1 = Monday, 7 = Sunday
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'kora_expense_tracker_recurring',
        'Recurring Notifications',
        channelDescription: 'Recurring notifications for Kora Expense Tracker',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule for each day
      for (final day in days) {
        final scheduledDate = _nextInstanceOfTime(hour, minute, day);
        await _notifications.schedule(
          id + day, // Unique ID for each day
          title,
          body,
          scheduledDate,
          details,
          payload: payload,
        );
      }
    } catch (e) {
      throw NotificationException(message: 'Failed to schedule recurring notification: $e');
    }
  }

  /// Cancel notification by ID
  Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
    } catch (e) {
      throw NotificationException(message: 'Failed to cancel notification: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
    } catch (e) {
      throw NotificationException(message: 'Failed to cancel all notifications: $e');
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      throw NotificationException(message: 'Failed to get pending notifications: $e');
    }
  }

  /// Show bill reminder notification
  Future<void> showBillReminder({
    required String billName,
    required double amount,
    required DateTime dueDate,
    required String currency,
  }) async {
    final title = 'Bill Reminder';
    final body = '$billName payment of ${_formatCurrency(amount, currency)} is due on ${_formatDate(dueDate)}';
    
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: 'bill_reminder:$billName:$amount:$currency',
    );
  }

  /// Schedule bill reminder
  Future<void> scheduleBillReminder({
    required String billName,
    required double amount,
    required DateTime dueDate,
    required String currency,
    int daysBefore = 1,
  }) async {
    final reminderDate = dueDate.subtract(Duration(days: daysBefore));
    
    if (reminderDate.isAfter(DateTime.now())) {
      final title = 'Bill Reminder';
      final body = '$billName payment of ${_formatCurrency(amount, currency)} is due in $daysBefore day${daysBefore > 1 ? 's' : ''}';
      
      await scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: title,
        body: body,
        scheduledDate: reminderDate,
        payload: 'bill_reminder:$billName:$amount:$currency',
      );
    }
  }

  /// Show low balance alert
  Future<void> showLowBalanceAlert({
    required String accountName,
    required double balance,
    required String currency,
    required double threshold,
  }) async {
    final title = 'Low Balance Alert';
    final body = '$accountName balance (${_formatCurrency(balance, currency)}) is below threshold (${_formatCurrency(threshold, currency)})';
    
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: 'low_balance:$accountName:$balance:$currency',
    );
  }

  /// Show credit card payment reminder
  Future<void> showCreditCardPaymentReminder({
    required String cardName,
    required double amount,
    required DateTime dueDate,
    required String currency,
  }) async {
    final title = 'Credit Card Payment Due';
    final body = '$cardName payment of ${_formatCurrency(amount, currency)} is due on ${_formatDate(dueDate)}';
    
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: 'credit_card_payment:$cardName:$amount:$currency',
    );
  }

  /// Schedule credit card payment reminder
  Future<void> scheduleCreditCardPaymentReminder({
    required String cardName,
    required double amount,
    required DateTime dueDate,
    required String currency,
    int daysBefore = 3,
  }) async {
    final reminderDate = dueDate.subtract(Duration(days: daysBefore));
    
    if (reminderDate.isAfter(DateTime.now())) {
      final title = 'Credit Card Payment Reminder';
      final body = '$cardName payment of ${_formatCurrency(amount, currency)} is due in $daysBefore day${daysBefore > 1 ? 's' : ''}';
      
      await scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: title,
        body: body,
        scheduledDate: reminderDate,
        payload: 'credit_card_payment:$cardName:$amount:$currency',
      );
    }
  }

  /// Show budget exceeded alert
  Future<void> showBudgetExceededAlert({
    required String category,
    required double spent,
    required double budget,
    required String currency,
  }) async {
    final title = 'Budget Exceeded';
    final body = 'You have exceeded your $category budget. Spent: ${_formatCurrency(spent, currency)}, Budget: ${_formatCurrency(budget, currency)}';
    
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: 'budget_exceeded:$category:$spent:$budget:$currency',
    );
  }

  /// Show monthly summary notification
  Future<void> showMonthlySummary({
    required double totalIncome,
    required double totalExpenses,
    required double netWorth,
    required String currency,
  }) async {
    final title = 'Monthly Summary';
    final body = 'Income: ${_formatCurrency(totalIncome, currency)}, Expenses: ${_formatCurrency(totalExpenses, currency)}, Net Worth: ${_formatCurrency(netWorth, currency)}';
    
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: 'monthly_summary:$totalIncome:$totalExpenses:$netWorth:$currency',
    );
  }

  /// Schedule monthly summary notification
  Future<void> scheduleMonthlySummary() async {
    // Schedule for the 1st of every month at 9 AM
    await scheduleRecurringNotification(
      id: 1000,
      title: 'Monthly Summary Available',
      body: 'Your monthly financial summary is ready to view',
      hour: 9,
      minute: 0,
      days: [1], // First day of month
      payload: 'monthly_summary_available',
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      _handleNotificationPayload(payload);
    }
  }

  /// Handle notification payload
  void _handleNotificationPayload(String payload) {
    final parts = payload.split(':');
    if (parts.isEmpty) return;

    switch (parts[0]) {
      case 'bill_reminder':
        // Navigate to bills screen
        break;
      case 'low_balance':
        // Navigate to accounts screen
        break;
      case 'credit_card_payment':
        // Navigate to credit cards screen
        break;
      case 'budget_exceeded':
        // Navigate to analytics screen
        break;
      case 'monthly_summary':
        // Navigate to analytics screen
        break;
      default:
        // Navigate to dashboard
        break;
    }
  }

  /// Format currency
  String _formatCurrency(double amount, String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return '₹${amount.toStringAsFixed(0)}';
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      default:
        return '$currency ${amount.toStringAsFixed(2)}';
    }
  }

  /// Format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Get next instance of time for recurring notifications
  DateTime _nextInstanceOfTime(int hour, int minute, int day) {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
    
    // If the time has already passed today, schedule for next occurrence
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    // Find the next occurrence of the specified day
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    try {
      final status = await Permission.notification.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Enable/disable notifications
  Future<bool> setNotificationsEnabled(bool enabled) async {
    try {
      if (enabled) {
        final status = await Permission.notification.request();
        return status.isGranted;
      } else {
        // Cancel all notifications
        await cancelAllNotifications();
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
