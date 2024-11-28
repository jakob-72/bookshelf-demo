import 'package:bookshelf_app/data/models/book.dart';
import 'package:flutter/material.dart';

sealed class AddBookResponse {
  const AddBookResponse();

  void when({
    required Function(Book) success,
    required Function() unauthorized,
    required Function() conflict,
    required Function(String) error,
  }) {
    if (this is Success) {
      success((this as Success).book);
    } else if (this is Unauthorized) {
      unauthorized();
    } else if (this is Conflict) {
      conflict();
    } else if (this is Error) {
      error((this as Error).message);
    }
  }

  factory AddBookResponse.success(Book book) = Success;

  factory AddBookResponse.unauthorized() = Unauthorized;

  factory AddBookResponse.conflict() = Conflict;

  factory AddBookResponse.error(String message) = Error;
}

@visibleForTesting
class Success extends AddBookResponse {
  final Book book;

  Success(this.book);
}

@visibleForTesting
class Unauthorized extends AddBookResponse {}

@visibleForTesting
class Conflict extends AddBookResponse {}

@visibleForTesting
class Error extends AddBookResponse {
  final String message;

  Error(this.message);
}
