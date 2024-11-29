import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/local_storage.dart';
import 'package:bookshelf_app/domain/check_token_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements LocalStorage {}

class MockBookService extends Mock implements BookService {}

void main() {
  late LocalStorage storage;
  late BookService bookService;
  late CheckTokenUseCase useCase;

  setUp(() {
    storage = MockStorage();
    bookService = MockBookService();
    useCase = CheckTokenUseCase(storage: storage, bookService: bookService);
  });

  test('returns true when a token is set and is valid', () async {
    when(() => storage.token).thenAnswer((_) => Future.value('token'));
    when(() => bookService.checkToken('token'))
        .thenAnswer((_) => Future.value(true));

    final result = await useCase.hasValidToken();

    expect(result, true);
  });

  test('returns false when a token is set and is invalid', () async {
    when(() => storage.token).thenAnswer((_) => Future.value('token'));
    when(() => bookService.checkToken('token'))
        .thenAnswer((_) => Future.value(false));

    final result = await useCase.hasValidToken();

    expect(result, false);
  });

  test('returns false when a token is not set', () async {
    when(() => storage.token).thenAnswer((_) => Future.value(null));

    final result = await useCase.hasValidToken();

    expect(result, false);
  });
}
