import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/app_provider.dart';

/// Settings Screen - Main screen for app settings and preferences
/// Location: lib/features/settings/screens/settings_screen.dart
/// Purpose: Display app settings, preferences, and configuration options
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Section
          _buildProfileSection(),
          
          const SizedBox(height: 24),
          
          // General Settings
          _buildSettingsSection(
            'General',
            [
              _buildSettingsTile(
                icon: Icons.palette,
                title: 'Theme',
                subtitle: 'Light, Dark, or System',
                trailing: Consumer<AppProvider>(
                  builder: (context, appProvider, child) {
                    return DropdownButton<ThemeMode>(
                      value: appProvider.themeMode,
                      onChanged: (ThemeMode? newValue) {
                        if (newValue != null) {
                          appProvider.setThemeMode(newValue);
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Dark'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('System'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              _buildSettingsTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () => _navigateToLanguageSettings(),
              ),
              _buildSettingsTile(
                icon: Icons.currency_exchange,
                title: 'Default Currency',
                subtitle: 'INR (₹)',
                onTap: () => _navigateToCurrencySettings(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Data & Privacy
          _buildSettingsSection(
            'Data & Privacy',
            [
              _buildSettingsTile(
                icon: Icons.backup,
                title: 'Backup & Sync',
                subtitle: 'Cloud backup settings',
                onTap: () => _navigateToBackupSettings(),
              ),
              _buildSettingsTile(
                icon: Icons.security,
                title: 'Security',
                subtitle: 'PIN, Biometric, and more',
                onTap: () => _navigateToSecuritySettings(),
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip,
                title: 'Privacy',
                subtitle: 'Data usage and permissions',
                onTap: () => _navigateToPrivacySettings(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Notifications
          _buildSettingsSection(
            'Notifications',
            [
              _buildSettingsTile(
                icon: Icons.notifications,
                title: 'Push Notifications',
                subtitle: 'Bill reminders and updates',
                trailing: Switch(
                  value: true, // TODO: Get from provider
                  onChanged: (value) {
                    // TODO: Update notification settings
                  },
                ),
              ),
              _buildSettingsTile(
                icon: Icons.schedule,
                title: 'Reminders',
                subtitle: 'Payment due dates',
                trailing: Switch(
                  value: true, // TODO: Get from provider
                  onChanged: (value) {
                    // TODO: Update reminder settings
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Advanced Features
          _buildSettingsSection(
            'Advanced Features',
            [
              _buildSettingsTile(
                icon: Icons.sms,
                title: 'SMS Parsing',
                subtitle: 'Auto-parse transaction SMS',
                trailing: Switch(
                  value: false, // TODO: Get from provider
                  onChanged: (value) {
                    // TODO: Update SMS parsing settings
                  },
                ),
              ),
              _buildSettingsTile(
                icon: Icons.analytics,
                title: 'Advanced Analytics',
                subtitle: 'Detailed financial insights',
                trailing: Switch(
                  value: true, // TODO: Get from provider
                  onChanged: (value) {
                    // TODO: Update analytics settings
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Support & About
          _buildSettingsSection(
            'Support & About',
            [
              _buildSettingsTile(
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'FAQs and contact support',
                onTap: () => _navigateToHelp(),
              ),
              _buildSettingsTile(
                icon: Icons.info,
                title: 'About',
                subtitle: 'App version and info',
                onTap: () => _navigateToAbout(),
              ),
              _buildSettingsTile(
                icon: Icons.star,
                title: 'Rate App',
                subtitle: 'Rate us on Play Store',
                onTap: () => _navigateToRateApp(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Danger Zone
          _buildSettingsSection(
            'Danger Zone',
            [
              _buildSettingsTile(
                icon: Icons.delete_forever,
                title: 'Delete All Data',
                subtitle: 'Permanently delete all data',
                onTap: () => _showDeleteDataConfirmation(),
                textColor: Colors.red,
              ),
              _buildSettingsTile(
                icon: Icons.logout,
                title: 'Reset App',
                subtitle: 'Reset to initial state',
                onTap: () => _showResetAppConfirmation(),
                textColor: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build profile section
  Widget _buildProfileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe', // TODO: Get from user data
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'john.doe@example.com', // TODO: Get from user data
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _navigateToEditProfile(),
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }

  /// Build settings section
  Widget _buildSettingsSection(String title, List<Widget> children) {
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

  /// Build settings tile
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: textColor?.withOpacity(0.7) ?? Colors.grey[600],
        ),
      ),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }

  /// Navigate to language settings
  void _navigateToLanguageSettings() {
    // TODO: Implement language settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language Settings - Coming Soon')),
    );
  }

  /// Navigate to currency settings
  void _navigateToCurrencySettings() {
    // TODO: Implement currency settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Currency Settings - Coming Soon')),
    );
  }

  /// Navigate to backup settings
  void _navigateToBackupSettings() {
    // TODO: Implement backup settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup Settings - Coming Soon')),
    );
  }

  /// Navigate to security settings
  void _navigateToSecuritySettings() {
    // TODO: Implement security settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security Settings - Coming Soon')),
    );
  }

  /// Navigate to privacy settings
  void _navigateToPrivacySettings() {
    // TODO: Implement privacy settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy Settings - Coming Soon')),
    );
  }

  /// Navigate to help
  void _navigateToHelp() {
    // TODO: Implement help navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help & Support - Coming Soon')),
    );
  }

  /// Navigate to about
  void _navigateToAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Kora Expense Tracker'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Build: 1'),
            SizedBox(height: 8),
            Text('A comprehensive personal finance tracker with multi-currency support and advanced analytics.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Navigate to rate app
  void _navigateToRateApp() {
    // TODO: Implement rate app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rate App - Coming Soon')),
    );
  }

  /// Navigate to edit profile
  void _navigateToEditProfile() {
    // TODO: Implement edit profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Profile - Coming Soon')),
    );
  }

  /// Show delete data confirmation
  void _showDeleteDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'This action cannot be undone. All your transactions, accounts, and settings will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllData();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Show reset app confirmation
  void _showResetAppConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App'),
        content: const Text(
          'This will reset the app to its initial state. All data will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetApp();
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Delete all data
  void _deleteAllData() {
    // TODO: Implement delete all data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete All Data - Coming Soon')),
    );
  }

  /// Reset app
  void _resetApp() {
    // TODO: Implement reset app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset App - Coming Soon')),
    );
  }
}
