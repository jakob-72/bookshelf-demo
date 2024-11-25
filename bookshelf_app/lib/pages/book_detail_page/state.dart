import 'package:bookshelf_app/data/models/book.dart';

sealed class BookDetailPageState {}

class Idle extends BookDetailPageState {
  final Book book;

  Idle(this.book);
}

class Loading extends BookDetailPageState {}

class Error extends BookDetailPageState {
  final String message;

  Error(this.message);
}
