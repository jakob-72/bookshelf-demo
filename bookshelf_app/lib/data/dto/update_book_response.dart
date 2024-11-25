import 'package:bookshelf_app/data/models/book.dart';

sealed class UpdateBookResponse {
  void when({
    required Function(Book) success,
    required Function() unauthorized,
    required Function(String) error,
  }) {
    if (this is Success) {
      success((this as Success).book);
    } else if (this is Unauthorized) {
      unauthorized();
    } else if (this is UpdateError) {
      error((this as UpdateError).message);
    }
  }
}

class Success extends UpdateBookResponse {
  final Book book;

  Success(this.book);
}

class Unauthorized extends UpdateBookResponse {}

class UpdateError extends UpdateBookResponse {
  final String message;

  UpdateError(this.message);
}
