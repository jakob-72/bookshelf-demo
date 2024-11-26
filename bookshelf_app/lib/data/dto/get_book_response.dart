import 'package:bookshelf_app/data/models/book.dart';

sealed class GetBookResponse {
  const GetBookResponse();

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

  factory GetBookResponse.success(Book book) = _Success;

  factory GetBookResponse.unauthorized() = _Unauthorized;

  factory GetBookResponse.notFound() = _NotFound;

  factory GetBookResponse.error(String message) = _Error;
}

class _Success extends GetBookResponse {
  final Book book;

  _Success(this.book);
}

class _Unauthorized extends GetBookResponse {}

class _NotFound extends GetBookResponse {}

class _Error extends GetBookResponse {
  final String message;

  _Error(this.message);
}
