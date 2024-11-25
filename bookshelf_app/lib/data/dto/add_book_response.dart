import 'package:bookshelf_app/data/models/book.dart';

sealed class AddBookResponse {
  void when({
    required Function(Book) success,
    required Function(AddBookUnauthorized) unauthorized,
    required Function(Conflict) conflict,
    required Function(String) error,
  }) {
    if (this is AddedSuccessfully) {
      success((this as AddedSuccessfully).book);
    } else if (this is AddBookUnauthorized) {
      unauthorized(this as AddBookUnauthorized);
    } else if (this is Conflict) {
      conflict(this as Conflict);
    } else if (this is AddBookError) {
      error((this as AddBookError).message);
    }
  }
}

class AddedSuccessfully extends AddBookResponse {
  final Book book;

  AddedSuccessfully(this.book);
}

class AddBookUnauthorized extends AddBookResponse {}

class Conflict extends AddBookResponse {}

class AddBookError extends AddBookResponse {
  final String message;

  AddBookError(this.message);
}
