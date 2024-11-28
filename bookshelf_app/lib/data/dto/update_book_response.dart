import 'package:bookshelf_app/data/models/book.dart';
import 'package:flutter/material.dart';

sealed class UpdateBookResponse {
  const UpdateBookResponse();

  void when({
    required Function(Book) success,
    required Function() unauthorized,
    required Function() notFound,
    required Function(String) error,
  }) {
    if (this is Success) {
      success((this as Success).book);
    } else if (this is Unauthorized) {
      unauthorized();
    } else if (this is NotFound) {
      notFound();
    } else if (this is Error) {
      error((this as Error).message);
    }
  }

  factory UpdateBookResponse.success(Book book) = Success;

  factory UpdateBookResponse.unauthorized() = Unauthorized;

  factory UpdateBookResponse.notFound() = NotFound;

  factory UpdateBookResponse.error(String message) = Error;
}

@visibleForTesting
class Success extends UpdateBookResponse {
  final Book book;

  Success(this.book);
}

@visibleForTesting
class Unauthorized extends UpdateBookResponse {}

@visibleForTesting
class NotFound extends UpdateBookResponse {}

@visibleForTesting
class Error extends UpdateBookResponse {
  final String message;

  Error(this.message);
}
