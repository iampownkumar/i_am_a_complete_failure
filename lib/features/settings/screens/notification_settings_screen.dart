import 'package:flutter/material.dart';
import '../../../core/services/notifications/notification_service.dart';

/// Notification Settings Screen
/// Location: lib/features/settings/screens/notification_settings_screen.dart
/// Purpose: Configure notification preferences and reminders
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  
  bool _notificationsEnabled = true;
  bool _billReminders = true;
  bool _lowBalanceAlerts = true;
  bool _creditCardReminders = true;
  bool _budgetAlerts = true;
  bool _monthlySummary = true;
  bool _transactionAlerts = false;
  
  int _billReminderDays = 1;
  int _creditCardReminderDays = 3;
  TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // General Notifications
          _buildSection(
            'General Notifications',
            [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Receive all app notifications'),
                value: _notificationsEnabled,
                onChanged: (value) async {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  await _notificationService.setNotificationsEnabled(value);
                  await _saveSettings();
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Reminder Settings
          _buildSection(
            'Reminder Settings',
            [
              SwitchListTile(
                title: const Text('Bill Reminders'),
                subtitle: const Text('Get reminded before bills are due'),
                value: _billReminders,
                onChanged: _notificationsEnabled ? (value) {
                  setState(() {
                    _billReminders = value;
                  });
                  _saveSettings();
                } : null,
              ),
              if (_billReminders) ...[
                ListTile(
                  title: const Text('Remind me'),
                  subtitle: Text('$_billReminderDays day${_billReminderDays > 1 ? 's' : ''} before due date'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _notificationsEnabled ? _showBillReminderDaysDialog : null,
                ),
              ],
              SwitchListTile(
                title: const Text('Credit Card Reminders'),
                subtitle: const Text('Get reminded before credit card payments'),
                value: _creditCardReminders,
                onChanged: _notificationsEnabled ? (value) {
                  setState(() {
                    _creditCardReminders = value;
                  });
                  _saveSettings();
                } : null,
              ),
              if (_creditCardReminders) ...[
                ListTile(
                  title: const Text('Remind me'),
                  subtitle: Text('$_creditCardReminderDays day${_creditCardReminderDays > 1 ? 's' : ''} before due date'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _notificationsEnabled ? _showCreditCardReminderDaysDialog : null,
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Alert Settings
          _buildSection(
            'Alert Settings',
            [
              SwitchListTile(
                title: const Text('Low Balance Alerts'),
                subtitle: const Text('Get notified when account balance is low'),
                value: _lowBalanceAlerts,
                onChanged: _notificationsEnabled ? (value) {
                  setState(() {
                    _lowBalanceAlerts = value;
                  });
                  _saveSettings();
                } : null,
              ),
              SwitchListTile(
                title: const Text('Budget Alerts'),
                subtitle: const Text('Get notified when you exceed budget limits'),
                value: _budgetAlerts,
                onChanged: _notificationsEnabled ? (value) {
                  setState(() {
                    _budgetAlerts = value;
                  });
                  _saveSettings();
                } : null,
              ),
              SwitchListTile(
                title: const Text('Transaction Alerts'),
                subtitle: const Text('Get notified for large transactions'),
                value: _transactionAlerts,
                onChanged: _notificationsEnabled ? (value) {
                  setState(() {
                    _transactionAlerts = value;
                  });
                  _saveSettings();
                } : null,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Summary Settings
          _buildSection(
            'Summary Settings',
            [
              SwitchListTile(
                title: const Text('Monthly Summary'),
                subtitle: const Text('Receive monthly financial summary'),
                value: _monthlySummary,
                onChanged: _notificationsEnabled ? (value) {
                  setState(() {
                    _monthlySummary = value;
                  });
                  _saveSettings();
                } : null,
              ),
              ListTile(
                title: const Text('Daily Reminder Time'),
                subtitle: Text('${_dailyReminderTime.format(context)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _notificationsEnabled ? _selectReminderTime : null,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Test Notifications
          _buildSection(
            'Test Notifications',
            [
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Test Notification'),
                subtitle: const Text('Send a test notification'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _notificationsEnabled ? _sendTestNotification : null,
              ),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Test Scheduled Notification'),
                subtitle: const Text('Schedule a test notification in 5 seconds'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _notificationsEnabled ? _sendTestScheduledNotification : null,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Notification History
          _buildSection(
            'Notification History',
            [
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('View Notification History'),
                subtitle: const Text('See all sent notifications'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _viewNotificationHistory,
              ),
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('Clear All Notifications'),
                subtitle: const Text('Cancel all scheduled notifications'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _clearAllNotifications,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build settings section
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  /// Load settings from storage
  Future<void> _loadSettings() async {
    // TODO: Load from SharedPreferences or database
    // For now, using default values
  }

  /// Save settings to storage
  Future<void> _saveSettings() async {
    // TODO: Save to SharedPreferences or database
  }

  /// Show bill reminder days dialog
  void _showBillReminderDaysDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bill Reminder Days'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(7, (index) {
            final days = index + 1;
            return RadioListTile<int>(
              title: Text('$days day${days > 1 ? 's' : ''} before'),
              value: days,
              groupValue: _billReminderDays,
              onChanged: (value) {
                setState(() {
                  _billReminderDays = value!;
                });
                Navigator.pop(context);
                _saveSettings();
              },
            );
          }),
        ),
      ),
    );
  }

  /// Show credit card reminder days dialog
  void _showCreditCardReminderDaysDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Credit Card Reminder Days'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(7, (index) {
            final days = index + 1;
            return RadioListTile<int>(
              title: Text('$days day${days > 1 ? 's' : ''} before'),
              value: days,
              groupValue: _creditCardReminderDays,
              onChanged: (value) {
                setState(() {
                  _creditCardReminderDays = value!;
                });
                Navigator.pop(context);
                _saveSettings();
              },
            );
          }),
        ),
      ),
    );
  }

  /// Select reminder time
  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _dailyReminderTime,
    );
    
    if (picked != null) {
      setState(() {
        _dailyReminderTime = picked;
      });
      _saveSettings();
    }
  }

  /// Send test notification
  Future<void> _sendTestNotification() async {
    try {
      await _notificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: 'Test Notification',
        body: 'This is a test notification from Kora Expense Tracker',
        payload: 'test_notification',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test notification sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send test notification: $e')),
      );
    }
  }

  /// Send test scheduled notification
  Future<void> _sendTestScheduledNotification() async {
    try {
      final scheduledTime = DateTime.now().add(const Duration(seconds: 5));
      
      await _notificationService.scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: 'Test Scheduled Notification',
        body: 'This is a test scheduled notification from Kora Expense Tracker',
        scheduledDate: scheduledTime,
        payload: 'test_scheduled_notification',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test scheduled notification set for 5 seconds from now!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to schedule test notification: $e')),
      );
    }
  }

  /// View notification history
  void _viewNotificationHistory() {
    // TODO: Implement notification history screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification History - Coming Soon')),
    );
  }

  /// Clear all notifications
  Future<void> _clearAllNotifications() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to cancel all scheduled notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        await _notificationService.cancelAllNotifications();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications cleared!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clear notifications: $e')),
        );
      }
    }
  }
}
