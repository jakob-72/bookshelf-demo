import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/domain/login_use_case.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';

class LoginPageModel {
  final AppRouter router;
  final LoginUseCase useCase;

  LoginPageModel({required this.router, required this.useCase});

  Future<AuthResponse> login(String username, String password) async =>
      useCase.login(username, password);

  void navigateToBooksPage() => router.replace(const BookOverviewRoute());
}
