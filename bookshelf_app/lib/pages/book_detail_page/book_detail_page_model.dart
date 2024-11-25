import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/domain/get_book_use_case.dart';
import 'package:bookshelf_app/domain/update_book_use_case.dart';
import 'package:bookshelf_app/pages/book_detail_page/state.dart';
import 'package:state_notifier/state_notifier.dart';

final initialState = Loading();

class BookDetailPageModel extends StateNotifier<BookDetailPageState>
    with LocatorMixin {
  BookDetailPageModel(this.bookId) : super(initialState);

  final String bookId;

  GetBookUseCase get getBookUseCase => read<GetBookUseCase>();

  UpdateBookUseCase get updateBookUseCase => read<UpdateBookUseCase>();

  Future<void> reload() async {
    state = Loading();
    final result = await getBookUseCase.getBook(bookId);
    result.when(
      success: (book) => state = Idle(book),
      notFound: (_) => state = Error('Book not found'),
      error: (message) => state = Error(message),
      unauthorized: (_) {
        // TODO navigate to login page
      },
    );
  }

  Future<void> saveBook(Book newBook) async {
    state = Loading();
    final result = await updateBookUseCase.updateBook(newBook);
    result.when(
      success: (book) => state = Idle(book),
      error: (message) => state = Error(message),
      unauthorized: () {
        // TODO navigate to login page
      },
    );
  }
}
