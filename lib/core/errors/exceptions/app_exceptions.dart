// File: lib/core/errors/exceptions/app_exceptions.dart
// Purpose: Custom exception classes for better error handling and debugging

abstract class AppException implements Exception {
  final String message;
  final String title;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    required this.title,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $title - $message';
}

class DatabaseException extends AppException {
  const DatabaseException({
    required String message,
    String title = 'Database Error',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          title: title,
          code: code,
          originalError: originalError,
        );
}

class NetworkException extends AppException {
  const NetworkException({
    required String message,
    String title = 'Network Error',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          title: title,
          code: code,
          originalError: originalError,
        );
}

class ValidationException extends AppException {
  const ValidationException({
    required String message,
    String title = 'Validation Error',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          title: title,
          code: code,
          originalError: originalError,
        );
}

class AuthenticationException extends AppException {
  const AuthenticationException({
    required String message,
    String title = 'Authentication Error',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          title: title,
          code: code,
          originalError: originalError,
        );
}

class PermissionException extends AppException {
  const PermissionException({
    required String message,
    String title = 'Permission Error',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          title: title,
          code: code,
          originalError: originalError,
        );
}

class FileException extends AppException {
  const FileException({
    required String message,
    String title = 'File Error',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          title: title,
          code: code,
          originalError: originalError,
        );
}

class CurrencyException extends AppException {
  const CurrencyException({
    required String message,
    String title = 'Currency Error',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          title: title,
          code: code,
          originalError: originalError,
        );
}

class SmsParsingException extends AppException {
  const SmsParsingException({
    required String message,
    String title = 'SMS Parsing Error',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          title: title,
          code: code,
          originalError: originalError,
        );
}

class NotificationException extends AppException {
  const NotificationException({
    required String message,
    String title = 'Notification Error',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          title: title,
          code: code,
          originalError: originalError,
        );
}
