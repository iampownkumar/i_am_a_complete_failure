// File: lib/core/errors/handlers/error_handler.dart
// Purpose: Global error handler for catching and managing errors throughout the app

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../exceptions/app_exceptions.dart';
import '../../constants/strings/app_strings.dart';

class ErrorHandler {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      } else {
        // Log error to crash reporting service in production
        _logError(details.exception, details.stack);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) {
        debugPrint('Platform error: $error');
        debugPrint('Stack trace: $stack');
      } else {
        // Log error to crash reporting service in production
        _logError(error, stack);
      }
      return true;
    };
  }

  static void _logError(dynamic error, StackTrace? stack) {
    // TODO: Implement crash reporting service (Firebase Crashlytics, Sentry, etc.)
    debugPrint('Error logged: $error');
    debugPrint('Stack trace: $stack');
  }

  static void handleError(BuildContext context, dynamic error) {
    String message = AppStrings.errorOccurred;
    String title = AppStrings.errorOccurred;

    if (error is AppException) {
      message = error.message;
      title = error.title;
    } else if (error is FormatException) {
      message = AppStrings.invalidInput;
    } else if (error is ArgumentError) {
      message = AppStrings.invalidInput;
    } else {
      message = AppStrings.somethingWentWrong;
    }

    _showErrorDialog(context, title, message);
  }

  static void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.tryAgain),
          ),
        ],
      ),
    );
  }

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
