import 'package:flutter/foundation.dart';

mixin Logger {
  static void log(String message, {String? operation}) {
    // here we could also add log to Crashlytics, Sentry, etc.
    if (kDebugMode) {
      print(operation != null ? '$operation: $message' : message);
    }
  }

  static void logError(Object error, {String? operation}) {
    // here we could also add log to Crashlytics, Sentry, etc.
    if (kDebugMode) {
      print(operation != null ? '$operation: $error' : error);
    }
  }
}
