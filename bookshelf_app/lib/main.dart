import 'package:bookshelf_app/data/auth_service.dart';
import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/client.dart';
import 'package:bookshelf_app/data/local_storage.dart';
import 'package:bookshelf_app/domain/check_token_use_case.dart';
import 'package:bookshelf_app/domain/get_books_use_case.dart';
import 'package:bookshelf_app/domain/login_use_case.dart';
import 'package:bookshelf_app/pages/books_overview_page/book_overview_page_model.dart';
import 'package:bookshelf_app/pages/login_page/login_page_model.dart';
import 'package:bookshelf_app/pages/start_page/start_page_model.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const authBaseUrl = 'http://localhost:8091';
const bookshelfBaseUrl = 'http://localhost:8090';

void main() {
  final router = AppRouter();
  final storage = LocalStorage();
  final authService = AuthService(Client.get(authBaseUrl));
  final bookService = BookService(Client.get(bookshelfBaseUrl));

  runApp(App(
    router: router,
    storage: storage,
    authService: authService,
    bookService: bookService,
  ));
}

class App extends StatelessWidget {
  final AppRouter router;
  final LocalStorage storage;
  final AuthService authService;
  final BookService bookService;

  const App({
    super.key,
    required this.router,
    required this.storage,
    required this.authService,
    required this.bookService,
  });

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ListenableProvider<AppRouter>.value(value: router),
          Provider<StartPageModel>.value(
            value: StartPageModel(
              router: router,
              useCase: CheckTokenUseCase(
                storage: storage,
                bookService: bookService,
              ),
            ),
          ),
          Provider<LoginPageModel>.value(
            value: LoginPageModel(
              router: router,
              useCase: LoginUseCase(
                authService,
                storage,
              ),
            ),
          ),
          Provider<BookOverviewPageModel>.value(
            value: BookOverviewPageModel(
              router: router,
              useCase: GetBooksUseCase(
                storage: storage,
                bookService: bookService,
              ),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Bookshelf',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
            scaffoldBackgroundColor: Colors.grey[850],
            useMaterial3: true,
            primaryColor: Colors.grey,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.grey),
              bodyMedium: TextStyle(color: Colors.grey),
              bodySmall: TextStyle(color: Colors.grey),
            ),
          ),
          routerConfig: router.config(),
        ),
      );
}
