import 'package:bookshelf_app/data/auth_service.dart';
import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';

class LoginUseCase {
  final AuthService _authService;
  final LocalStorage _localStorage;

  LoginUseCase(this._authService, this._localStorage);

  Future<AuthResponse> login(String username, String password) async {
    final result = await _authService.login(username, password);
    if (result is AuthSuccess) {
      _localStorage.setToken(result.token);
    }
    return result;
  }
}
