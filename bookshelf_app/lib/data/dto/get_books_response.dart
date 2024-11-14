import 'package:bookshelf_app/data/models/book.dart';

sealed class GetBooksResponse {}

class GetBooksResponseSuccess extends GetBooksResponse {
  final List<Book> books;

  GetBooksResponseSuccess(this.books);
}

class GetBooksResponseUnauthorized extends GetBooksResponse {}

class GetBooksResponseError extends GetBooksResponse {
  final String message;

  GetBooksResponseError(this.message);
}
