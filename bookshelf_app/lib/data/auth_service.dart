import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/shared/logger.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio dio;

  const AuthService(this.dio);

  Future<AuthResponse> login(String username, String password) async {
    const operation = 'AuthService_login';
    try {
      final response = await dio.post(
        '/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(validateStatus: (_) => true),
      );
      if (response.statusCode == 200) {
        return AuthSuccess(response.data['token']);
      } else if (response.statusCode == 401) {
        return Unauthorized();
      } else {
        Logger.log(
          'Authentication error - ${response.statusCode}: ${response.data}',
          operation: operation,
        );
        return AuthError('${response.statusCode}: ${response.data}');
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return AuthError(e.message ?? 'Internal error');
    }
  }
}
