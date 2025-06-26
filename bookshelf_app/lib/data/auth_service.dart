import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/data/dto/register_response.dart';
import 'package:bookshelf_app/shared/logger.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio dio;

  const AuthService(this.dio);

  Future<AuthResponse> login(String username, String password) async {
    const operation = 'AuthService_login';
    Response? response;
    try {
      response = await dio.post(
        '/login',
        data: {'username': username, 'password': password},
        options: Options(validateStatus: (_) => true),
      );
      if (response.statusCode == 200) {
        return AuthResponse.success(response.data['token']);
      } else if (response.statusCode == 401) {
        return AuthResponse.unauthorized();
      } else {
        Logger.log(
          'Authentication error - ${response.statusCode}: ${response.data}',
          operation: operation,
        );
        return AuthResponse.error('${response.statusCode}: ${response.data}');
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return AuthResponse.error(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return AuthResponse.error(
        'Error parsing response: $e, data: ${response?.data}',
      );
    }
  }

  Future<RegisterResponse> register(String username, String password) async {
    const operation = 'AuthService_register';
    try {
      final response = await dio.post(
        '/register',
        data: {'username': username, 'password': password},
        options: Options(validateStatus: (_) => true),
      );
      if (response.statusCode == 201) {
        return RegisterResponse.success();
      } else if (response.statusCode == 409) {
        return RegisterResponse.conflict();
      } else {
        Logger.log(
          'Registration error - ${response.statusCode}: ${response.data}',
          operation: operation,
        );
        return RegisterResponse.error(
          '${response.statusCode}: ${response.data}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return RegisterResponse.error(e.message ?? 'Internal error');
    }
  }
}
