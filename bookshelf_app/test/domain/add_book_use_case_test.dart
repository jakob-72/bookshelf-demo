import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/add_book_request.dart';
import 'package:bookshelf_app/data/dto/add_book_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';
import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/domain/add_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements LocalStorage {}

class MockBookService extends Mock implements BookService {}

void main() {
  late LocalStorage storage;
  late BookService bookService;
  late AddBookUseCase useCase;

  setUp(() {
    storage = MockStorage();
    bookService = MockBookService();
    useCase = AddBookUseCase(bookService: bookService, storage: storage);
  });

  test(
    'return AddBookResponse.success when token is set and request succeeds',
    () async {
      const title = 'title';
      const author = 'author';
      when(() => storage.token).thenAnswer((_) => Future.value('token'));
      when(
        () => bookService.addBook(
          'token',
          AddBookRequest(title: title, author: author, read: false),
        ),
      ).thenAnswer(
        (_) =>
            Future.value(Success(Book(id: 'id', title: title, author: author))),
      );

      final response = await useCase.addBook(title: title, author: author);

      expect(response.runtimeType, Success);
      expect((response as Success).book.id, 'id');
      expect(response.book.title, title);
      expect(response.book.author, author);
    },
  );

  test('returns AddBookResponse.unauthorized when token is null', () async {
    when(() => storage.token).thenAnswer((_) => Future.value(null));

    final response = await useCase.addBook(title: 'title', author: 'author');

    expect(response.runtimeType, Unauthorized);
    verifyZeroInteractions(bookService);
  });
}
