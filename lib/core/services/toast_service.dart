import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Toast types for different message categories
enum ToastType {
  success,
  error,
  warning,
  info,
}

/// Centralized toast service for showing ephemeral messages
///
/// Usage:
/// ```dart
/// ToastService().success("Operation completed!");
/// ToastService().error("Something went wrong");
/// ```
class ToastService {
  factory ToastService() => _instance;
  ToastService._internal();
  // Singleton pattern
  static final ToastService _instance = ToastService._internal();

  /// Show a toast message with specified type
  void show(
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Color backgroundColor;
    var textColor = Colors.white;

    // Determine colors based on type
    switch (type) {
      case ToastType.success:
        backgroundColor = const Color(0xFF27AE60); // Green
        break;
      case ToastType.error:
        backgroundColor = const Color(0xFFE74C3C); // Red
        break;
      case ToastType.warning:
        backgroundColor = const Color(0xFFF39C12); // Orange
        break;
      case ToastType.info:
        backgroundColor = const Color(0xFF3498DB); // Blue
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength:
          duration.inSeconds > 3 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: duration.inSeconds,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16,
    );
  }

  /// Show success toast (green)
  void success(String message, {Duration? duration}) {
    show(
      message,
      type: ToastType.success,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Show error toast (red)
  void error(String message, {Duration? duration}) {
    show(
      message,
      type: ToastType.error,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  /// Show warning toast (orange)
  void warning(String message, {Duration? duration}) {
    show(
      message,
      type: ToastType.warning,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Show info toast (blue)
  void info(String message, {Duration? duration}) {
    show(
      message,
      type: ToastType.info,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Cancel all active toasts
  void cancel() {
    Fluttertoast.cancel();
  }
}
