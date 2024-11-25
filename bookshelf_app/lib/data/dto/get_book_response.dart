import 'package:bookshelf_app/data/models/book.dart';

sealed class GetBookResponse {
  void when({
    required Function(Book) success,
    required Function(GetBookUnauthorized) unauthorized,
    required Function(GetBookNotFound) notFound,
    required Function(String) error,
  }) {
    if (this is GetBookSuccess) {
      success((this as GetBookSuccess).book);
    } else if (this is GetBookUnauthorized) {
      unauthorized(this as GetBookUnauthorized);
    } else if (this is GetBookNotFound) {
      notFound(this as GetBookNotFound);
    } else if (this is GetBookError) {
      error((this as GetBookError).message);
    }
  }
}

class GetBookSuccess extends GetBookResponse {
  final Book book;

  GetBookSuccess(this.book);
}

class GetBookUnauthorized extends GetBookResponse {}

class GetBookNotFound extends GetBookResponse {}

class GetBookError extends GetBookResponse {
  final String message;

  GetBookError(this.message);
}
