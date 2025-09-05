// File: lib/shared/providers/app_provider.dart
// Purpose: Main app provider for managing global app state and settings

import 'package:flutter/material.dart';
import '../../core/constants/enums/app_enums.dart';
import '../../core/services/database/database_service.dart';

class AppProvider extends ChangeNotifier {
  // Theme and UI state
  ThemeMode _themeMode = ThemeMode.system;
  bool _isFirstLaunch = true;
  bool _isMaterial3Enabled = true;
  
  // App state
  bool _isLoading = false;
  String? _errorMessage;
  
  // User preferences
  Currency _defaultCurrency = Currency.inr;
  bool _smsParsingEnabled = false;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _hideSensitiveData = false;
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isMaterial3Enabled => _isMaterial3Enabled;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Currency get defaultCurrency => _defaultCurrency;
  bool get smsParsingEnabled => _smsParsingEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get biometricEnabled => _biometricEnabled;
  bool get hideSensitiveData => _hideSensitiveData;
  
  AppProvider() {
    _loadSettings();
  }
  
  // Load settings from database
  Future<void> _loadSettings() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Load theme mode
      final themeModeString = await DatabaseService.instance.getSetting('theme_mode');
      if (themeModeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (e) => e.name == themeModeString,
          orElse: () => ThemeMode.system,
        );
      }
      
      // Load first launch status
      final firstLaunchString = await DatabaseService.instance.getSetting('is_first_launch');
      _isFirstLaunch = firstLaunchString != 'false';
      
      // Load material 3 setting
      final material3String = await DatabaseService.instance.getSetting('material_3_enabled');
      _isMaterial3Enabled = material3String != 'false';
      
      // Load default currency
      final currencyString = await DatabaseService.instance.getSetting('default_currency');
      if (currencyString != null) {
        _defaultCurrency = Currency.values.firstWhere(
          (e) => e.name == currencyString,
          orElse: () => Currency.inr,
        );
      }
      
      // Load SMS parsing setting
      final smsParsingString = await DatabaseService.instance.getSetting('sms_parsing_enabled');
      _smsParsingEnabled = smsParsingString == 'true';
      
      // Load notifications setting
      final notificationsString = await DatabaseService.instance.getSetting('notifications_enabled');
      _notificationsEnabled = notificationsString != 'false';
      
      // Load biometric setting
      final biometricString = await DatabaseService.instance.getSetting('biometric_enabled');
      _biometricEnabled = biometricString == 'true';
      
      // Load hide sensitive data setting
      final hideSensitiveString = await DatabaseService.instance.getSetting('hide_sensitive_data');
      _hideSensitiveData = hideSensitiveString == 'true';
      
    } catch (e) {
      _errorMessage = 'Failed to load settings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Theme methods
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    DatabaseService.instance.setSetting('theme_mode', mode.name);
    notifyListeners();
  }
  
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
  
  // First launch methods
  void completeOnboarding() {
    _isFirstLaunch = false;
    DatabaseService.instance.setSetting('is_first_launch', 'false');
    notifyListeners();
  }
  
  // Material 3 methods
  void setMaterial3Enabled(bool enabled) {
    _isMaterial3Enabled = enabled;
    DatabaseService.instance.setSetting('material_3_enabled', enabled.toString());
    notifyListeners();
  }
  
  // Currency methods
  void setDefaultCurrency(Currency currency) {
    _defaultCurrency = currency;
    DatabaseService.instance.setSetting('default_currency', currency.name);
    notifyListeners();
  }
  
  // SMS parsing methods
  void setSmsParsingEnabled(bool enabled) {
    _smsParsingEnabled = enabled;
    DatabaseService.instance.setSetting('sms_parsing_enabled', enabled.toString());
    notifyListeners();
  }
  
  // Notifications methods
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    DatabaseService.instance.setSetting('notifications_enabled', enabled.toString());
    notifyListeners();
  }
  
  // Biometric methods
  void setBiometricEnabled(bool enabled) {
    _biometricEnabled = enabled;
    DatabaseService.instance.setSetting('biometric_enabled', enabled.toString());
    notifyListeners();
  }
  
  // Hide sensitive data methods
  void setHideSensitiveData(bool hide) {
    _hideSensitiveData = hide;
    DatabaseService.instance.setSetting('hide_sensitive_data', hide.toString());
    notifyListeners();
  }
  
  // Loading methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  // Error methods
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  // Reset all settings
  Future<void> resetSettings() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Reset to default values
      _themeMode = ThemeMode.system;
      _isFirstLaunch = true;
      _isMaterial3Enabled = true;
      _defaultCurrency = Currency.inr;
      _smsParsingEnabled = false;
      _notificationsEnabled = true;
      _biometricEnabled = false;
      _hideSensitiveData = false;
      
      // Clear database settings
      await DatabaseService.instance.setSetting('theme_mode', 'system');
      await DatabaseService.instance.setSetting('is_first_launch', 'true');
      await DatabaseService.instance.setSetting('material_3_enabled', 'true');
      await DatabaseService.instance.setSetting('default_currency', 'inr');
      await DatabaseService.instance.setSetting('sms_parsing_enabled', 'false');
      await DatabaseService.instance.setSetting('notifications_enabled', 'true');
      await DatabaseService.instance.setSetting('biometric_enabled', 'false');
      await DatabaseService.instance.setSetting('hide_sensitive_data', 'false');
      
    } catch (e) {
      _errorMessage = 'Failed to reset settings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
