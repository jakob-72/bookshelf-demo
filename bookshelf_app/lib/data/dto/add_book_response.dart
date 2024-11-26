import 'package:bookshelf_app/data/models/book.dart';

sealed class AddBookResponse {
  const AddBookResponse();

  void when({
    required Function(Book) success,
    required Function() unauthorized,
    required Function() conflict,
    required Function(String) error,
  }) {
    if (this is _Success) {
      success((this as _Success).book);
    } else if (this is _Unauthorized) {
      unauthorized();
    } else if (this is _Conflict) {
      conflict();
    } else if (this is _Error) {
      error((this as _Error).message);
    }
  }

  factory AddBookResponse.success(Book book) = _Success;

  factory AddBookResponse.unauthorized() = _Unauthorized;

  factory AddBookResponse.conflict() = _Conflict;

  factory AddBookResponse.error(String message) = _Error;
}

class _Success extends AddBookResponse {
  final Book book;

  _Success(this.book);
}

class _Unauthorized extends AddBookResponse {}

class _Conflict extends AddBookResponse {}

class _Error extends AddBookResponse {
  final String message;

  _Error(this.message);
}
