/// Simple Logger for Gura Now
/// Logs to console with timestamps and levels
library;

import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

class AppLogger {
  static const String _tag = 'Gura Now';
  static LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.warning;

  /// Set minimum log level (filters lower severity logs)
  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Get current timestamp
  static String _getTimestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
  }

  /// Get level emoji
  static String _getLevelEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.critical:
        return '🔴';
    }
  }

  /// Get level string
  static String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARN';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.critical:
        return 'CRITICAL';
    }
  }

  /// Internal log method
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minLevel.index) return;

    final timestamp = _getTimestamp();
    final emoji = _getLevelEmoji(level);
    final levelStr = _getLevelString(level);
    final logTag = tag ?? _tag;

    // Format: [timestamp] emoji [TAG] LEVEL: message
    debugPrint(
      '[$timestamp] $emoji [$logTag] $levelStr: $message',
    );

    if (error != null) {
      debugPrint('Error: $error');
    }

    if (stackTrace != null) {
      debugPrint('StackTrace:\n$stackTrace');
    }
  }

  /// Log debug message
  static void debug(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.debug,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log info message
  static void info(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.info,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log warning message
  static void warning(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.warning,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log error message
  static void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log critical message
  static void critical(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.critical,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Convenience methods without tag parameter
  static void d(String message) => debug(message);
  static void i(String message) => info(message);
  static void w(String message) => warning(message);
  static void e(String message, {dynamic error, StackTrace? stackTrace}) =>
      AppLogger.error(message, error: error, stackTrace: stackTrace);
  static void c(String message) => critical(message);
}
