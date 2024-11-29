import 'package:bookshelf_app/data/auth_service.dart';
import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/data/dto/register_response.dart'
    as register_response;
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late Dio dio;
  late AuthService authService;

  setUp(() {
    dio = MockDio();
    authService = AuthService(dio);
  });

  group('login', () {
    const path = '/login';

    test('returns a token when login succeeds', () async {
      const username = 'username';
      const password = 'password';
      when(() => dio.post(
            path,
            data: {
              'username': username,
              'password': password,
            },
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            statusCode: 200,
            data: {'token': 'testToken'},
            requestOptions: RequestOptions(),
          ));

      final result = await authService.login(username, password);

      expect(result.runtimeType, Success);
      expect((result as Success).token, 'testToken');
    });

    test('returns AuthResponse.unauthorized when login fails with 401',
        () async {
      const username = 'username';
      const password = 'password';
      when(() => dio.post(
            path,
            data: {
              'username': username,
              'password': password,
            },
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            statusCode: 401,
            requestOptions: RequestOptions(),
          ));

      final result = await authService.login(username, password);

      expect(result.runtimeType, Unauthorized);
    });

    test('returns AuthResponse.error for an unexpected status code', () async {
      const username = 'username';
      const password = 'password';
      when(() => dio.post(
            path,
            data: {
              'username': username,
              'password': password,
            },
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            statusCode: 400,
            data: 'testError',
            requestOptions: RequestOptions(),
          ));

      final result = await authService.login(username, password);

      expect(result.runtimeType, Error);
      expect((result as Error).message, '400: testError');
    });

    test('returns AuthResponse.error when connection fails', () async {
      const username = 'username';
      const password = 'password';
      when(() => dio.post(
            path,
            data: {
              'username': username,
              'password': password,
            },
            options: any(named: 'options'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
        ),
      ));

      final result = await authService.login(username, password);

      expect(result.runtimeType, Error);
      expect((result as Error).message, 'Internal error');
    });

    test('return AuthResponse.error when response body cannot be parsed',
        () async {
      const username = 'username';
      const password = 'password';
      when(() => dio.post(
            path,
            data: {
              'username': username,
              'password': password,
            },
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            statusCode: 200,
            data: '{invalidJson',
            requestOptions: RequestOptions(),
          ));

      final result = await authService.login(username, password);

      expect(result.runtimeType, Error);
      expect(
        (result as Error).message,
        'Error parsing response: type \'String\' is not a subtype of type \'int\' of \'index\', data: {invalidJson',
      );
    });
  });

  group('Register', () {
    const path = '/register';

    test('returns RegisterResponse.success when registration succeeds',
        () async {
      const username = 'username';
      const password = 'password';
      when(() => dio.post(
            path,
            data: {
              'username': username,
              'password': password,
            },
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            statusCode: 201,
            requestOptions: RequestOptions(),
          ));

      final result = await authService.register(username, password);

      expect(result.runtimeType, register_response.Success);
    });

    test(
        'returns RegisterResponse.conflict when registration fails with status 409',
        () async {
      const username = 'username';
      const password = 'password';
      when(() => dio.post(
            path,
            data: {
              'username': username,
              'password': password,
            },
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            statusCode: 409,
            requestOptions: RequestOptions(),
          ));

      final result = await authService.register(username, password);

      expect(result.runtimeType, register_response.Conflict);
    });

    test('returns RegisterResponse.error for an unexpected status code',
        () async {
      const username = 'username';
      const password = 'password';
      when(() => dio.post(
            path,
            data: {
              'username': username,
              'password': password,
            },
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            statusCode: 400,
            data: 'testError',
            requestOptions: RequestOptions(),
          ));

      final result = await authService.register(username, password);

      expect(result.runtimeType, register_response.Error);
      expect((result as register_response.Error).message, '400: testError');
    });

    test('returns RegisterResponse.error when connection fails', () async {
      const username = 'username';
      const password = 'password';
      when(() => dio.post(
            path,
            data: {
              'username': username,
              'password': password,
            },
            options: any(named: 'options'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
        ),
      ));

      final result = await authService.register(username, password);

      expect(result.runtimeType, register_response.Error);
      expect((result as register_response.Error).message, 'Internal error');
    });
  });
}
