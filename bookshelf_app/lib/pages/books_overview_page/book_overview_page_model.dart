import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/domain/add_book_use_case.dart';
import 'package:bookshelf_app/domain/get_books_use_case.dart';
import 'package:bookshelf_app/domain/logout_use_case.dart';
import 'package:bookshelf_app/pages/books_overview_page/state.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';
import 'package:state_notifier/state_notifier.dart';

final initialState = Idle([]);

class BookOverviewPageModel extends StateNotifier<BooksOverviewPageState>
    with LocatorMixin {
  BookOverviewPageModel() : super(initialState);

  AppRouter get router => read<AppRouter>();

  GetBooksUseCase get getBooksUseCase => read<GetBooksUseCase>();

  AddBookUseCase get addBookUseCase => read<AddBookUseCase>();

  LogoutUseCase get logoutUseCase => read<LogoutUseCase>();

  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    state = Loading(_books);
    final result = await getBooksUseCase.getBooks();
    result.when(
      success: (books) {
        _books = books;
        state = Idle(_books);
      },
      unauthorized: () => navigateToLoginPage(),
      error: (error) => state = Error(_books, error),
    );
  }

  Future<void> addBook({
    required String title,
    required String author,
    String? genre,
    int? rating,
    bool read = false,
  }) async {
    state = Loading(_books);
    final result = await addBookUseCase.addBook(
      title: title,
      author: author,
      genre: genre,
      rating: rating,
      read: read,
    );
    result.when(
      success: (book) {
        _books.add(book);
        state = Idle(_books);
      },
      unauthorized: (_) => navigateToLoginPage(),
      conflict: (_) => state = Error(_books, 'This Book already exists'),
      error: (error) => state = Error(_books, error),
    );
  }

  Future<void> logout() async {
    await logoutUseCase.logout();
    router.replace(LoginRoute());
  }

  void navigateToLoginPage() => router.replace(LoginRoute(unauthorized: true));

  void navigateToBookDetailPage(String id) =>
      router.push(BookDetailRoute(bookId: id));
}
