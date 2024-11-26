import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/domain/delete_book_use_case.dart';
import 'package:bookshelf_app/domain/get_book_use_case.dart';
import 'package:bookshelf_app/domain/update_book_use_case.dart';
import 'package:bookshelf_app/pages/book_detail_page/state.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';
import 'package:state_notifier/state_notifier.dart';

final initialState = Loading();

class BookDetailPageModel extends StateNotifier<BookDetailPageState>
    with LocatorMixin {
  BookDetailPageModel(this.bookId) : super(initialState);

  final String bookId;

  AppRouter get router => read<AppRouter>();

  GetBookUseCase get getBookUseCase => read<GetBookUseCase>();

  UpdateBookUseCase get updateBookUseCase => read<UpdateBookUseCase>();

  DeleteBookUseCase get deleteBookUseCase => read<DeleteBookUseCase>();

  Future<void> reload() async {
    state = Loading();
    final result = await getBookUseCase.getBook(bookId);
    result.when(
      success: (book) => state = Idle(book),
      notFound: () => state = Error('Book not found'),
      error: (message) => state = Error(message),
      unauthorized: () => router.pushAndPopUntil(
        LoginRoute(unauthorized: true),
        predicate: (_) => true,
      ),
    );
  }

  Future<void> saveBook(Book newBook) async {
    state = Loading();
    final result = await updateBookUseCase.updateBook(newBook);
    result.when(
      success: (book) {
        state = Idle(book);
        router.pushAndPopUntil(
          const BookOverviewRoute(),
          predicate: (_) => true,
        );
      },
      error: (message) => state = Error(message),
      unauthorized: () => router.pushAndPopUntil(
        LoginRoute(unauthorized: true),
        predicate: (_) => true,
      ),
      notFound: () => state = Error('Book not found'),
    );
  }

  Future<void> deleteBook() async {
    state = Loading();
    final result = await deleteBookUseCase.deleteBook(bookId);
    result.when(
      success: () => router.pushAndPopUntil(
        const BookOverviewRoute(),
        predicate: (_) => true,
      ),
      notFound: () => state = Error('Book not found'),
      error: (message) => state = Error(message),
      unauthorized: () => router.pushAndPopUntil(
        LoginRoute(unauthorized: true),
        predicate: (_) => true,
      ),
    );
  }
}
