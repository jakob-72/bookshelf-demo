import 'package:bookshelf_app/data/models/book.dart';

sealed class GetBooksResponse {
  void when({
    required Function(List<Book> books) success,
    required Function() unauthorized,
    required Function(String message) error,
  }) {
    if (this is GetBooksResponseSuccess) {
      success((this as GetBooksResponseSuccess).books);
    } else if (this is GetBooksResponseUnauthorized) {
      unauthorized();
    } else if (this is GetBooksResponseError) {
      error((this as GetBooksResponseError).message);
    }
  }
}

class GetBooksResponseSuccess extends GetBooksResponse {
  final List<Book> books;

  GetBooksResponseSuccess(this.books);
}

class GetBooksResponseUnauthorized extends GetBooksResponse {}

class GetBooksResponseError extends GetBooksResponse {
  final String message;

  GetBooksResponseError(this.message);
}
