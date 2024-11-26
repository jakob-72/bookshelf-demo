import 'package:bookshelf_app/data/models/book.dart';

sealed class GetBooksResponse {
  const GetBooksResponse();

  void when({
    required Function(List<Book> books) success,
    required Function() unauthorized,
    required Function(String message) error,
  }) {
    if (this is _Success) {
      success((this as _Success).books);
    } else if (this is _Unauthorized) {
      unauthorized();
    } else if (this is _Error) {
      error((this as _Error).message);
    }
  }

  factory GetBooksResponse.success(List<Book> books) = _Success;

  factory GetBooksResponse.unauthorized() = _Unauthorized;

  factory GetBooksResponse.error(String message) = _Error;
}

class _Success extends GetBooksResponse {
  final List<Book> books;

  _Success(this.books);
}

class _Unauthorized extends GetBooksResponse {}

class _Error extends GetBooksResponse {
  final String message;

  _Error(this.message);
}
