import 'package:flutter/material.dart';

sealed class RegisterResponse {
  const RegisterResponse();

  void when({
    required Function() registerSuccess,
    required Function() registerConflict,
    required Function(String message) registerError,
  }) {
    if (this is Success) {
      registerSuccess();
    } else if (this is Conflict) {
      registerConflict();
    } else if (this is Error) {
      registerError((this as Error).message);
    }
  }

  factory RegisterResponse.success() = Success;

  factory RegisterResponse.conflict() = Conflict;

  factory RegisterResponse.error(String message) = Error;
}

@visibleForTesting
class Success extends RegisterResponse {}

@visibleForTesting
class Conflict extends RegisterResponse {}

@visibleForTesting
class Error extends RegisterResponse {
  final String message;

  Error(this.message);
}
