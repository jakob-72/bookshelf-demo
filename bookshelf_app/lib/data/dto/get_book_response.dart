import 'package:bookshelf_app/data/models/book.dart';
import 'package:flutter/material.dart';

sealed class GetBookResponse {
  const GetBookResponse();

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

  factory GetBookResponse.success(Book book) = Success;

  factory GetBookResponse.unauthorized() = Unauthorized;

  factory GetBookResponse.notFound() = NotFound;

  factory GetBookResponse.error(String message) = Error;
}

@visibleForTesting
class Success extends GetBookResponse {
  final Book book;

  Success(this.book);
}

@visibleForTesting
class Unauthorized extends GetBookResponse {}

@visibleForTesting
class NotFound extends GetBookResponse {}

@visibleForTesting
class Error extends GetBookResponse {
  final String message;

  Error(this.message);
}
