import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/get_book_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';
import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/domain/get_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements LocalStorage {}

class MockBookService extends Mock implements BookService {}

void main() {
  late LocalStorage storage;
  late BookService bookService;
  late GetBookUseCase useCase;

  setUp(() {
    storage = MockStorage();
    bookService = MockBookService();
    useCase = GetBookUseCase(storage: storage, bookService: bookService);
  });

  test('returns GetBookResponse.success when token is set and request succeeds',
      () async {
    final book = Book(id: 'id', title: 'title', author: 'author');
    when(() => storage.token).thenAnswer((_) => Future.value('token'));
    when(() => bookService.getBook('token', 'bookId'))
        .thenAnswer((_) => Future.value(GetBookResponse.success(book)));

    final result = await useCase.getBook('bookId');

    expect(result.runtimeType, GetBookResponse.success(book).runtimeType);
    expect((result as Success).book, book);
  });

  test('returns unauthorized when a token is not set', () async {
    when(() => storage.token).thenAnswer((_) => Future.value(null));

    final result = await useCase.getBook('bookId');

    expect(result.runtimeType, GetBookResponse.unauthorized().runtimeType);
  });
}
