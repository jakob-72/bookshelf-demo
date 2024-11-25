import 'dart:io';

import 'package:bookshelf_app/data/auth_service.dart';
import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/client.dart';
import 'package:bookshelf_app/data/local_storage.dart';
import 'package:bookshelf_app/domain/add_book_use_case.dart';
import 'package:bookshelf_app/domain/check_token_use_case.dart';
import 'package:bookshelf_app/domain/get_book_use_case.dart';
import 'package:bookshelf_app/domain/get_books_use_case.dart';
import 'package:bookshelf_app/domain/login_use_case.dart';
import 'package:bookshelf_app/domain/logout_use_case.dart';
import 'package:bookshelf_app/domain/register_use_case.dart';
import 'package:bookshelf_app/domain/update_book_use_case.dart';
import 'package:bookshelf_app/pages/start_page/start_page_model.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String get authBaseUrl {
  const port = '8091';
  try {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:$port';
    }
  } catch (_) {
    // ignore - safeguard for web
  }
  return 'http://localhost:$port';
}

String get bookServiceBaseUrl {
  const port = '8090';
  try {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:$port';
    }
  } catch (_) {
    // ignore - safeguard for web
  }
  return 'http://localhost:$port';
}

void main() {
  final router = AppRouter();
  final storage = LocalStorage();
  final authService = AuthService(Client.get(authBaseUrl));
  final bookService = BookService(Client.get(bookServiceBaseUrl));

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
          Provider<LoginUseCase>.value(
            value: LoginUseCase(authService: authService, storage: storage),
          ),
          Provider<RegisterUseCase>.value(
            value: RegisterUseCase(authService: authService),
          ),
          Provider<GetBooksUseCase>.value(
            value: GetBooksUseCase(storage: storage, bookService: bookService),
          ),
          Provider<GetBookUseCase>.value(
            value: GetBookUseCase(storage: storage, bookService: bookService),
          ),
          Provider<AddBookUseCase>.value(
            value: AddBookUseCase(storage: storage, bookService: bookService),
          ),
          Provider<LogoutUseCase>.value(value: LogoutUseCase(storage: storage)),
          Provider<UpdateBookUseCase>.value(
            value:
                UpdateBookUseCase(storage: storage, bookService: bookService),
          ),
          Provider<StartPageModel>.value(
            value: StartPageModel(
              router: router,
              useCase: CheckTokenUseCase(
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
            appBarTheme: AppBarTheme(
              actionsIconTheme: const IconThemeData(color: Colors.grey),
              iconTheme: const IconThemeData(color: Colors.grey),
              backgroundColor: Colors.grey[850],
              titleTextStyle: const TextStyle(color: Colors.grey),
            ),
            useMaterial3: true,
            primaryColor: Colors.grey,
            dialogBackgroundColor: Colors.grey[800],
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
