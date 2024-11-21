import 'package:bookshelf_app/data/auth_service.dart';
import 'package:bookshelf_app/data/dto/auth_response.dart';

class RegisterUseCase {
  final AuthService authService;

  const RegisterUseCase({required this.authService});

  Future<AuthResponse> register(String username, String password) async =>
      authService.register(username, password);
}
