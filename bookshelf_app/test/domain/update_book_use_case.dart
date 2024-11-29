import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/update_book_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';
import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/domain/update_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements LocalStorage {}

class MockBookService extends Mock implements BookService {}

void main() {
  late LocalStorage storage;
  late BookService bookService;
  late UpdateBookUseCase useCase;

  setUp(() {
    storage = MockStorage();
    bookService = MockBookService();
    useCase = UpdateBookUseCase(storage: storage, bookService: bookService);
  });

  test(
      'returns UpdateBookResponse.success when token is set and request succeeds',
      () async {
    final book = Book(id: 'id', title: 'title', author: 'author');
    when(() => storage.token).thenAnswer((_) => Future.value('token'));
    when(() => bookService.updateBook('token', book))
        .thenAnswer((_) => Future.value(UpdateBookResponse.success(book)));

    final result = await useCase.updateBook(book);

    expect(result.runtimeType, UpdateBookResponse.success(book).runtimeType);
    expect((result as Success).book, book);
  });

  test('returns unauthorized when a token is not set', () async {
    when(() => storage.token).thenAnswer((_) => Future.value(null));

    final result = await useCase
        .updateBook(Book(id: 'id', title: 'title', author: 'author'));

    expect(result.runtimeType, UpdateBookResponse.unauthorized().runtimeType);
  });
}
