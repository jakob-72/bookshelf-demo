import 'package:bookshelf_app/data/models/book.dart';

sealed class BooksOverviewPageState {
  final List<Book> books;

  BooksOverviewPageState(this.books);
}

class Idle extends BooksOverviewPageState {
  Idle(super.books);
}

class Loading extends BooksOverviewPageState {
  Loading(super.books);
}

class Changed extends BooksOverviewPageState {
  Changed(super.books);
}

class Error extends BooksOverviewPageState {
  final String message;

  Error(super.books, this.message);
}
