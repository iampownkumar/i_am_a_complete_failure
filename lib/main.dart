// File: lib/main.dart
// Purpose: Entry point of the app - initializes providers, error handling, and theme

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/strings/app_strings.dart';
import 'core/errors/handlers/error_handler.dart';
import 'core/services/database/database_service.dart';
import 'shared/providers/app_provider.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/navigation/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Initialize database
  await DatabaseService.instance.initialize();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const KoraExpenseTrackerApp());
}

class KoraExpenseTrackerApp extends StatelessWidget {
  const KoraExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        // Add other providers here as needed
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appProvider.themeMode,
            home: const AppInitializer(),
            builder: (context, child) {
              ErrorHandler.initialize();
              return child!;
            },
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        // Check if user has completed onboarding
        if (appProvider.isFirstLaunch) {
          return const OnboardingScreen();
        }
        
        // Return main navigation with bottom tabs
        return const MainNavigationScreen();
      },
    );
  }
}