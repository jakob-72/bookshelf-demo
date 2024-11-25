import 'package:bookshelf_app/data/auth_service.dart';
import 'package:bookshelf_app/data/dto/register_response.dart';

class RegisterUseCase {
  final AuthService authService;

  const RegisterUseCase({required this.authService});

  Future<RegisterResponse> register(String username, String password) async =>
      authService.register(username, password);
}
