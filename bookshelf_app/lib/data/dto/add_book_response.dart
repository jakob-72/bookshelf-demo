import 'package:bookshelf_app/data/models/book.dart';

sealed class AddBookResponse {}

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
