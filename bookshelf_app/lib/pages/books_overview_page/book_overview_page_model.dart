import 'package:bookshelf_app/data/dto/get_books_response.dart';
import 'package:bookshelf_app/domain/get_books_use_case.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';

class BookOverviewPageModel {
  final AppRouter router;
  final GetBooksUseCase useCase;

  BookOverviewPageModel({required this.router, required this.useCase});

  Future<GetBooksResponse> getBooks() async => useCase.getBooks();

  void navigateToLoginPage() => router.replace(LoginRoute(unauthorized: true));
}
