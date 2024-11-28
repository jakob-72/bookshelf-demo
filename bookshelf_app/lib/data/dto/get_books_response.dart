import 'package:bookshelf_app/data/models/book.dart';
import 'package:flutter/material.dart';

sealed class GetBooksResponse {
  const GetBooksResponse();

  void when({
    required Function(List<Book> books) success,
    required Function() unauthorized,
    required Function(String message) error,
  }) {
    if (this is Success) {
      success((this as Success).books);
    } else if (this is Unauthorized) {
      unauthorized();
    } else if (this is Error) {
      error((this as Error).message);
    }
  }

  factory GetBooksResponse.success(List<Book> books) = Success;

  factory GetBooksResponse.unauthorized() = Unauthorized;

  factory GetBooksResponse.error(String message) = Error;
}

@visibleForTesting
class Success extends GetBooksResponse {
  final List<Book> books;

  Success(this.books);
}

@visibleForTesting
class Unauthorized extends GetBooksResponse {}

@visibleForTesting
class Error extends GetBooksResponse {
  final String message;

  Error(this.message);
}
