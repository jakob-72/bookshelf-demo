import 'package:bookshelf_app/data/auth_service.dart';
import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';
import 'package:bookshelf_app/domain/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements LocalStorage {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  late LocalStorage storage;
  late AuthService authService;
  late LoginUseCase useCase;

  setUp(() {
    storage = MockStorage();
    authService = MockAuthService();
    useCase = LoginUseCase(authService: authService, storage: storage);
  });

  test('returns AuthResponse.success when login succeeds', () async {
    when(
      () => authService.login('username', 'password'),
    ).thenAnswer((_) async => AuthResponse.success('token'));
    when(() => storage.setToken('token')).thenAnswer((_) async {});

    final result = await useCase.login('username', 'password');

    expect(result.runtimeType, AuthResponse.success('').runtimeType);
    verify(() => storage.setToken('token')).called(1);
  });

  test(
    'returns AuthResponse.unauthorized and dont save token when login fails',
    () async {
      when(
        () => authService.login('username', 'password'),
      ).thenAnswer((_) async => AuthResponse.unauthorized());
      when(() => storage.setToken('token')).thenAnswer((_) async {});

      final result = await useCase.login('username', 'password');

      expect(result.runtimeType, AuthResponse.unauthorized().runtimeType);
      verifyNever(() => storage.setToken('token'));
    },
  );
}
