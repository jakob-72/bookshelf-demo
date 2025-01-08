import 'package:bookshelf_app/data/models/book.dart';

sealed class BooksOverviewPageState {
  final List<Book> books;

  BooksOverviewPageState(this.books);
}

class Idle extends BooksOverviewPageState {
  final String? searchTerm;

  Idle(super.books, {this.searchTerm});
}

class Loading extends BooksOverviewPageState {
  Loading(super.books);
}

class Error extends BooksOverviewPageState {
  final String message;

  Error(super.books, this.message);
}
