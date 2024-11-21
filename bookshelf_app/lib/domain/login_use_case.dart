import 'package:bookshelf_app/data/auth_service.dart';
import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';

class LoginUseCase {
  final AuthService authService;
  final LocalStorage storage;

  LoginUseCase({required this.authService, required this.storage});

  Future<AuthResponse> login(String username, String password) async {
    final result = await authService.login(username, password);
    if (result is AuthSuccess) {
      storage.setToken(result.token);
    }
    return result;
  }
}
