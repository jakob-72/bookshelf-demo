import 'package:bookshelf_app/data/dto/add_book_response.dart';
import 'package:bookshelf_app/data/dto/get_books_response.dart';
import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/domain/add_book_use_case.dart';
import 'package:bookshelf_app/domain/get_books_use_case.dart';
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

  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    state = Loading(_books);
    final result = await getBooksUseCase.getBooks();
    if (result is GetBooksResponseSuccess) {
      _books = result.books;
      state = Idle(_books);
    } else if (result is GetBooksResponseUnauthorized) {
      navigateToLoginPage();
    } else {
      state = Error(_books, (result as GetBooksResponseError).message);
    }
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
    if (result is AddedSuccessfully) {
      _books.add(result.book);
      state = Idle(_books);
    } else if (result is AddBookUnauthorized) {
      navigateToLoginPage();
    } else if (result is Conflict) {
      state = Error(_books, 'This Book already exists');
    } else {
      state = Error(_books, (result as AddBookError).message);
    }
  }

  void navigateToLoginPage() => router.replace(LoginRoute(unauthorized: true));

  void navigateToBookDetailPage(Book book) =>
      router.push(BookDetailRoute(book: book));
}
