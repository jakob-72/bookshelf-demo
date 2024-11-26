import 'package:bookshelf_app/data/models/book.dart';

sealed class UpdateBookResponse {
  const UpdateBookResponse();

  void when({
    required Function(Book) success,
    required Function() unauthorized,
    required Function() notFound,
    required Function(String) error,
  }) {
    if (this is _Success) {
      success((this as _Success).book);
    } else if (this is _Unauthorized) {
      unauthorized();
    } else if (this is _NotFound) {
      notFound();
    } else if (this is _Error) {
      error((this as _Error).message);
    }
  }

  factory UpdateBookResponse.success(Book book) = _Success;

  factory UpdateBookResponse.unauthorized() = _Unauthorized;

  factory UpdateBookResponse.notFound() = _NotFound;

  factory UpdateBookResponse.error(String message) = _Error;
}

class _Success extends UpdateBookResponse {
  final Book book;

  _Success(this.book);
}

class _Unauthorized extends UpdateBookResponse {}

class _NotFound extends UpdateBookResponse {}

class _Error extends UpdateBookResponse {
  final String message;

  _Error(this.message);
}
