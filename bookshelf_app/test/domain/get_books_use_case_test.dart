import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/get_books_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';
import 'package:bookshelf_app/domain/get_books_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements LocalStorage {}

class MockBookService extends Mock implements BookService {}

void main() {
  late LocalStorage storage;
  late BookService bookService;
  late GetBooksUseCase useCase;

  setUp(() {
    storage = MockStorage();
    bookService = MockBookService();
    useCase = GetBooksUseCase(storage: storage, bookService: bookService);
  });

  test(
    'returns GetBooksResponse.success when token is set and request succeeds',
    () async {
      when(() => storage.token).thenAnswer((_) => Future.value('token'));
      when(
        () => bookService.getBooks('token', null),
      ).thenAnswer((_) => Future.value(GetBooksResponse.success([])));

      final result = await useCase.getBooks();

      expect(result.runtimeType, GetBooksResponse.success([]).runtimeType);
    },
  );

  test('returns unauthorized when a token is not set', () async {
    when(() => storage.token).thenAnswer((_) => Future.value(null));

    final result = await useCase.getBooks();

    expect(result.runtimeType, GetBooksResponse.unauthorized().runtimeType);
  });
}
