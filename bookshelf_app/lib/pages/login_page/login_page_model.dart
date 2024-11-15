import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/domain/login_use_case.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';
import 'package:flutter/material.dart';

class LoginPageModel extends ChangeNotifier {
  final AppRouter router;
  final LoginUseCase useCase;

  AuthResponse? _result;

  AuthResponse? get result => _result;

  LoginPageModel({required this.router, required this.useCase});

  Future<void> login(String username, String password) async {
    _result = await useCase.login(username, password);
    notifyListeners();
  }

  void navigateToBooksPage() => router.replace(const BookOverviewRoute());
}
