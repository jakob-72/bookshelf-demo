import 'package:flutter/material.dart';

sealed class DeleteBookResponse {
  const DeleteBookResponse();

  void when({
    required void Function() success,
    required void Function() unauthorized,
    required void Function() notFound,
    required void Function(String message) error,
  }) {
    if (this is Success) {
      success();
    } else if (this is Unauthorized) {
      unauthorized();
    } else if (this is NotFound) {
      notFound();
    } else if (this is Error) {
      error((this as Error).message);
    }
  }

  factory DeleteBookResponse.success() = Success;

  factory DeleteBookResponse.unauthorized() = Unauthorized;

  factory DeleteBookResponse.notFound() = NotFound;

  factory DeleteBookResponse.error(String message) = Error;
}

@visibleForTesting
class Success extends DeleteBookResponse {}

@visibleForTesting
class Unauthorized extends DeleteBookResponse {}

@visibleForTesting
class NotFound extends DeleteBookResponse {}

@visibleForTesting
class Error extends DeleteBookResponse {
  final String message;

  Error(this.message);
}
