import 'package:flutter/foundation.dart';

class Logger {
  static void debug(String message) {
    debugPrint('[DEBUG] $message');
  }

  static void info(String message) {
    debugPrint('[INFO] $message');
  }

  static void warning(String message) {
    debugPrint('[WARN] $message');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    debugPrint('[ERROR] $message');
    if (error != null) debugPrint('error: $error');
    if (stackTrace != null) debugPrint('$stackTrace');
  }
}
