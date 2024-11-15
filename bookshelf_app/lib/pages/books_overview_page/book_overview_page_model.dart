import 'package:bookshelf_app/data/dto/get_books_response.dart';
import 'package:bookshelf_app/domain/get_books_use_case.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';
import 'package:flutter/material.dart';

class BookOverviewPageModel extends ChangeNotifier {
  final AppRouter router;
  final GetBooksUseCase useCase;

  GetBooksResponse? _result;

  GetBooksResponse? get result => _result;

  BookOverviewPageModel({required this.router, required this.useCase});

  Future<void> refresh() async {
    _result = await useCase.getBooks();
    notifyListeners();
  }

  void navigateToLoginPage() => router.replace(LoginRoute(unauthorized: true));
}
