import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/delete_book_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';
import 'package:bookshelf_app/domain/delete_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements LocalStorage {}

class MockBookService extends Mock implements BookService {}

void main() {
  late LocalStorage storage;
  late BookService bookService;
  late DeleteBookUseCase useCase;

  setUp(() {
    storage = MockStorage();
    bookService = MockBookService();
    useCase = DeleteBookUseCase(storage: storage, bookService: bookService);
  });

  test(
    'returns DeleteBookResponse.success when token is set and request succeeds',
    () async {
      when(() => storage.token).thenAnswer((_) => Future.value('token'));
      when(
        () => bookService.deleteBook('token', 'bookId'),
      ).thenAnswer((_) => Future.value(DeleteBookResponse.success()));

      final result = await useCase.deleteBook('bookId');

      expect(result.runtimeType, DeleteBookResponse.success().runtimeType);
    },
  );

  test('returns unauthorized when a token is not set', () async {
    when(() => storage.token).thenAnswer((_) => Future.value(null));

    final result = await useCase.deleteBook('bookId');

    expect(result.runtimeType, DeleteBookResponse.unauthorized().runtimeType);
  });
}
