import 'package:flutter/foundation.dart';

mixin Logger {
  static DateTime get now => DateTime.now();

  static void log(String message, {String? operation}) {
    // here we could also add log to Crashlytics, Sentry, etc.
    if (kDebugMode) {
      final log = {
        'level': 'INFO',
        'timestamp': now,
        'operation': operation,
        'message': message,
      };
      print(log);
    }
  }

  static void logError(Object error, {String? operation}) {
    // here we could also add log to Crashlytics, Sentry, etc.
    if (kDebugMode) {
      final log = {
        'level': 'ERROR',
        'timestamp': now,
        'operation': operation,
        'error': error.toString(),
      };
      print(log);
    }
  }
}
