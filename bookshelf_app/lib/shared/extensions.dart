import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

extension SnackbarExtension on BuildContext {
  void showSnackbar(String message, {duration = const Duration(seconds: 3)}) =>
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          ScaffoldMessenger.of(this).showSnackBar(
            SnackBar(
              content: Center(child: Text(message)),
              duration: duration,
            ),
          );
        },
      );
}
