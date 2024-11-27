import 'package:flutter/material.dart';

sealed class AuthResponse {
  const AuthResponse();

  void when({
    required Function(String token) success,
    required Function() unauthorized,
    required Function(String) error,
  }) {
    if (this is Success) {
      success((this as Success).token);
    } else if (this is Unauthorized) {
      unauthorized();
    } else if (this is Error) {
      error((this as Error).message);
    }
  }

  factory AuthResponse.success(String token) = Success;

  factory AuthResponse.unauthorized() = Unauthorized;

  factory AuthResponse.error(String message) = Error;
}

@visibleForTesting
class Success extends AuthResponse {
  final String token;

  Success(this.token);
}

@visibleForTesting
class Unauthorized extends AuthResponse {}

@visibleForTesting
class Error extends AuthResponse {
  final String message;

  Error(this.message);
}
