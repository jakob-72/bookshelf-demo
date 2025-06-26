import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/add_book_request.dart';
import 'package:bookshelf_app/data/dto/add_book_response.dart' as add_response;
import 'package:bookshelf_app/data/dto/get_book_response.dart' as book_response;
import 'package:bookshelf_app/data/dto/get_books_response.dart'
    as books_response;
import 'package:bookshelf_app/data/dto/update_book_response.dart'
    as update_response;
import 'package:bookshelf_app/data/dto/delete_book_response.dart'
    as delete_response;
import 'package:bookshelf_app/data/models/book.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late Dio dio;
  late BookService bookService;

  setUp(() {
    dio = MockDio();
    bookService = BookService(dio);
  });

  group('Check Token', () {
    const path = '/check';

    test('returns true when token is valid', () async {
      when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
        (_) async =>
            Response(statusCode: 200, requestOptions: RequestOptions()),
      );

      final result = await bookService.checkToken('testToken');

      expect(result, true);
    });

    test('returns false when token is invalid', () async {
      when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
        (_) async =>
            Response(statusCode: 401, requestOptions: RequestOptions()),
      );

      final result = await bookService.checkToken('falseToken');

      expect(result, false);
    });

    test('returns false when an error occurs', () async {
      when(() => dio.get(path, options: any(named: 'options'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          response: Response(requestOptions: RequestOptions(path: path)),
        ),
      );

      final result = await bookService.checkToken('testToken');

      expect(result, false);
    });
  });

  group('Get Books', () {
    const path = '/books';

    test(
      'returns GetBooksResponse.success when books are fetched successfully',
      () async {
        when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            data: [
              {'id': '1', 'title': 'Book 1', 'author': 'Test'},
              {'id': '2', 'title': 'Book 2', 'author': 'Test'},
            ],
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.getBooks('testToken', null);

        expect(result, isA<books_response.Success>());
        expect((result as books_response.Success).books.length, 2);
        expect(result.books[0].id, '1');
        expect(result.books[1].title, 'Book 2');
      },
    );

    test(
      'returns GetBooksResponse.success and builds query correctly when searchTerm is provided',
      () async {
        when(
          () => dio.get(
            path,
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            data: [
              {'id': '1', 'title': 'Book 1', 'author': 'Test'},
              {'id': '2', 'title': 'Book 2', 'author': 'Test'},
            ],
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.getBooks('testToken', 'testSearch');

        expect(result, isA<books_response.Success>());
        expect((result as books_response.Success).books.length, 2);
        expect(result.books[0].id, '1');
        expect(result.books[1].title, 'Book 2');
        verify(
          () => dio.get(
            path,
            options: any(named: 'options'),
            queryParameters: {'search': 'testSearch'},
          ),
        ).called(1);
      },
    );

    test(
      'returns GetBooksResponse.unauthorized when response status is 401',
      () async {
        when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
          (_) async =>
              Response(statusCode: 401, requestOptions: RequestOptions()),
        );

        final result = await bookService.getBooks('testToken', null);

        expect(result, isA<books_response.Unauthorized>());
      },
    );

    test(
      'returns GetBooksResponse.error for unexpected status codes',
      () async {
        when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
          (_) async => Response(
            statusCode: 400,
            data: 'testError',
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.getBooks('testToken', null);

        expect(result, isA<books_response.Error>());
        expect((result as books_response.Error).message, '400: testError');
      },
    );

    test('returns GetBooksResponse.error when request fails', () async {
      when(() => dio.get(path, options: any(named: 'options'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          response: Response(requestOptions: RequestOptions(path: path)),
        ),
      );

      final result = await bookService.getBooks('testToken', null);

      expect(result, isA<books_response.Error>());
      expect((result as books_response.Error).message, 'Internal error');
    });

    test(
      'returns GetBooksResponse.error when books are missing required fields',
      () async {
        when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            data: [
              {'id': '1', 'author': 'Test'},
            ],
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.getBooks('testToken', null);

        expect(result, isA<books_response.Error>());
        expect(
          (result as books_response.Error).message,
          'Error parsing response: type \'Null\' is not a subtype of type \'String\', data: [{id: 1, author: Test}]',
        );
      },
    );

    test(
      'returns GetBooksResponse.error when response is invalid json',
      () async {
        when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            data: '{invalidJson',
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.getBooks('testToken', null);

        expect(result, isA<books_response.Error>());
        expect(
          (result as books_response.Error).message,
          'Error parsing response: type \'String\' is not a subtype of type \'List<dynamic>\' in type cast, data: {invalidJson',
        );
      },
    );
  });

  group('Get Book', () {
    const path = '/books/1';

    test(
      'returns GetBookResponse.success when book is fetched successfully',
      () async {
        when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            data: {'id': '1', 'title': 'Book 1', 'author': 'Test'},
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.getBook('testToken', '1');

        expect(result, isA<book_response.Success>());
        expect((result as book_response.Success).book.id, '1');
        expect(result.book.title, 'Book 1');
      },
    );

    test(
      'returns GetBookResponse.unauthorized when response status is 401',
      () async {
        when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
          (_) async =>
              Response(statusCode: 401, requestOptions: RequestOptions()),
        );

        final result = await bookService.getBook('testToken', '1');

        expect(result, isA<book_response.Unauthorized>());
      },
    );

    test(
      'returns GetBookResponse.notFound when response status is 404',
      () async {
        when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
          (_) async =>
              Response(statusCode: 404, requestOptions: RequestOptions()),
        );

        final result = await bookService.getBook('testToken', '1');

        expect(result, isA<book_response.NotFound>());
      },
    );

    test('returns GetBookResponse.error for unexpected status codes', () async {
      when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          statusCode: 400,
          data: 'testError',
          requestOptions: RequestOptions(),
        ),
      );

      final result = await bookService.getBook('testToken', '1');

      expect(result, isA<book_response.Error>());
      expect((result as book_response.Error).message, '400: testError');
    });

    test('returns GetBookResponse.error when request fails', () async {
      when(() => dio.get(path, options: any(named: 'options'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          response: Response(requestOptions: RequestOptions(path: path)),
        ),
      );

      final result = await bookService.getBook('testToken', '1');

      expect(result, isA<book_response.Error>());
      expect((result as book_response.Error).message, 'Internal error');
    });

    test('returns GetBookResponse.error when response is invalid json', () async {
      when(() => dio.get(path, options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          data: '{invalidJson',
          requestOptions: RequestOptions(),
        ),
      );

      final result = await bookService.getBook('testToken', '1');

      expect(result, isA<book_response.Error>());
      expect(
        (result as book_response.Error).message,
        'Error parsing response: type \'String\' is not a subtype of type \'Map<String, dynamic>\' in type cast, data: {invalidJson',
      );
    });
  });

  group('Add Book', () {
    const path = '/books';

    test(
      'returns AddBookResponse.success when book is added successfully',
      () async {
        when(
          () => dio.post(
            path,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 201,
            data: {'id': '1', 'title': 'New Book', 'author': 'Test'},
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.addBook(
          'testToken',
          AddBookRequest(title: 'New Book', author: 'Test', read: false),
        );

        expect(result, isA<add_response.Success>());
        expect((result as add_response.Success).book.id, '1');
        expect(result.book.title, 'New Book');
      },
    );

    test(
      'returns AddBookResponse.unauthorized when response status is 401',
      () async {
        when(
          () => dio.post(
            path,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async =>
              Response(statusCode: 401, requestOptions: RequestOptions()),
        );

        final result = await bookService.addBook(
          'testToken',
          AddBookRequest(title: 'New Book', author: 'Test', read: true),
        );

        expect(result, isA<add_response.Unauthorized>());
      },
    );

    test(
      'returns AddBookResponse.conflict when response status is 409',
      () async {
        when(
          () => dio.post(
            path,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async =>
              Response(statusCode: 409, requestOptions: RequestOptions()),
        );

        final result = await bookService.addBook(
          'testToken',
          AddBookRequest(title: 'New Book', author: 'Test', read: false),
        );

        expect(result, isA<add_response.Conflict>());
      },
    );

    test('returns AddBookResponse.error for unexpected status codes', () async {
      when(
        () => dio.post(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          statusCode: 400,
          data: 'Bad Request',
          requestOptions: RequestOptions(),
        ),
      );

      final result = await bookService.addBook(
        'testToken',
        AddBookRequest(title: 'New Book', author: 'Test', read: false),
      );

      expect(result, isA<add_response.Error>());
      expect((result as add_response.Error).message, '400: Bad Request');
    });

    test('returns AddBookResponse.error when request fails', () async {
      when(
        () => dio.post(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          response: Response(requestOptions: RequestOptions(path: path)),
        ),
      );

      final result = await bookService.addBook(
        'testToken',
        AddBookRequest(title: 'New Book', author: 'Test', read: true),
      );

      expect(result, isA<add_response.Error>());
      expect((result as add_response.Error).message, 'Internal error');
    });

    test('returns AddBookResponse.error when response is invalid json', () async {
      when(
        () => dio.post(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          statusCode: 201,
          data: '{invalidJson',
          requestOptions: RequestOptions(),
        ),
      );

      final result = await bookService.addBook(
        'testToken',
        AddBookRequest(title: 'New Book', author: 'Test', read: false),
      );

      expect(result, isA<add_response.Error>());
      expect(
        (result as add_response.Error).message,
        'Error parsing response: type \'String\' is not a subtype of type \'Map<String, dynamic>\' in type cast, data: {invalidJson',
      );
    });
  });

  group('Update Book', () {
    const path = '/books/1';

    test(
      'returns UpdateBookResponse.success when book is updated successfully',
      () async {
        when(
          () => dio.put(
            path,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            data: {'id': '1', 'title': 'Updated Book', 'author': 'Test'},
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.updateBook(
          'testToken',
          Book(id: '1', title: 'Updated Book', author: 'Test'),
        );

        expect(result, isA<update_response.Success>());
        expect((result as update_response.Success).book.id, '1');
        expect(result.book.title, 'Updated Book');
      },
    );

    test(
      'returns UpdateBookResponse.unauthorized when response status is 401',
      () async {
        when(
          () => dio.put(
            path,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async =>
              Response(statusCode: 401, requestOptions: RequestOptions()),
        );

        final result = await bookService.updateBook(
          'testToken',
          Book(id: '1', title: 'Updated Book', author: 'Test'),
        );

        expect(result, isA<update_response.Unauthorized>());
      },
    );

    test(
      'returns UpdateBookResponse.notFound when response status is 404',
      () async {
        when(
          () => dio.put(
            path,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async =>
              Response(statusCode: 404, requestOptions: RequestOptions()),
        );

        final result = await bookService.updateBook(
          'testToken',
          Book(id: '1', title: 'Updated Book', author: 'Test'),
        );

        expect(result, isA<update_response.NotFound>());
      },
    );

    test(
      'returns UpdateBookResponse.error for unexpected status codes',
      () async {
        when(
          () => dio.put(
            path,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 400,
            data: 'Bad Request',
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.updateBook(
          'testToken',
          Book(id: '1', title: 'Updated Book', author: 'Test'),
        );

        expect(result, isA<update_response.Error>());
        expect((result as update_response.Error).message, '400: Bad Request');
      },
    );

    test('returns UpdateBookResponse.error when request fails', () async {
      when(
        () => dio.put(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          response: Response(requestOptions: RequestOptions(path: path)),
        ),
      );

      final result = await bookService.updateBook(
        'testToken',
        Book(id: '1', title: 'Updated Book', author: 'Test'),
      );

      expect(result, isA<update_response.Error>());
      expect((result as update_response.Error).message, 'Internal error');
    });

    test(
      'returns UpdateBookResponse.error when response is invalid json',
      () async {
        when(
          () => dio.put(
            path,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            data: '{invalidJson',
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.updateBook(
          'testToken',
          Book(id: '1', title: 'Updated Book', author: 'Test'),
        );

        expect(result, isA<update_response.Error>());
        expect(
          (result as update_response.Error).message,
          'Error parsing response: type \'String\' is not a subtype of type \'Map<String, dynamic>\' in type cast, data: {invalidJson',
        );
      },
    );
  });

  group('Delete Book', () {
    const path = '/books/1';

    test(
      'returns DeleteBookResponse.success when book is deleted successfully',
      () async {
        when(() => dio.delete(path, options: any(named: 'options'))).thenAnswer(
          (_) async =>
              Response(statusCode: 204, requestOptions: RequestOptions()),
        );

        final result = await bookService.deleteBook('testToken', '1');

        expect(result, isA<delete_response.Success>());
      },
    );

    test(
      'returns DeleteBookResponse.unauthorized when response status is 401',
      () async {
        when(() => dio.delete(path, options: any(named: 'options'))).thenAnswer(
          (_) async =>
              Response(statusCode: 401, requestOptions: RequestOptions()),
        );

        final result = await bookService.deleteBook('testToken', '1');

        expect(result, isA<delete_response.Unauthorized>());
      },
    );

    test(
      'returns DeleteBookResponse.notFound when response status is 404',
      () async {
        when(() => dio.delete(path, options: any(named: 'options'))).thenAnswer(
          (_) async =>
              Response(statusCode: 404, requestOptions: RequestOptions()),
        );

        final result = await bookService.deleteBook('testToken', '1');

        expect(result, isA<delete_response.NotFound>());
      },
    );

    test(
      'returns DeleteBookResponse.error for unexpected status codes',
      () async {
        when(() => dio.delete(path, options: any(named: 'options'))).thenAnswer(
          (_) async => Response(
            statusCode: 400,
            data: 'Bad Request',
            requestOptions: RequestOptions(),
          ),
        );

        final result = await bookService.deleteBook('testToken', '1');

        expect(result, isA<delete_response.Error>());
        expect((result as delete_response.Error).message, '400: Bad Request');
      },
    );

    test('returns DeleteBookResponse.error when request fails', () async {
      when(() => dio.delete(path, options: any(named: 'options'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          response: Response(requestOptions: RequestOptions(path: path)),
        ),
      );

      final result = await bookService.deleteBook('testToken', '1');

      expect(result, isA<delete_response.Error>());
      expect((result as delete_response.Error).message, 'Internal error');
    });
  });
}
