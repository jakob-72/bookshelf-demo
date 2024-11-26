import 'package:bookshelf_app/data/dto/add_book_request.dart';
import 'package:bookshelf_app/data/dto/add_book_response.dart';
import 'package:bookshelf_app/data/dto/delete_book_response.dart';
import 'package:bookshelf_app/data/dto/get_book_response.dart';
import 'package:bookshelf_app/data/dto/get_books_response.dart';
import 'package:bookshelf_app/data/dto/update_book_response.dart';
import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/shared/logger.dart';
import 'package:dio/dio.dart';

class BookService {
  final Dio dio;

  BookService(this.dio);

  Future<bool> checkToken(String token) async {
    const operation = 'bookService_checkToken';
    const path = '/check';
    try {
      final response = await dio.get(
        path,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return false;
    }
  }

  Future<GetBooksResponse> getBooks(String token) async {
    const operation = 'bookService_getBooks';
    const path = '/books';
    Response? response;
    try {
      response = await dio.get(
        path,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (_) => true,
        ),
      );
      if (response.statusCode == 200) {
        final books = (response.data as List)
            .map((obj) => Book.fromJson(obj as Map<String, dynamic>))
            .toList();
        return GetBooksResponseSuccess(books);
      } else if (response.statusCode == 401) {
        return GetBooksResponseUnauthorized();
      } else {
        Logger.log(
          'Failed to get books: ${response.statusCode} ${response.statusMessage}',
          operation: operation,
        );
        return GetBooksResponseError(
          '${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return GetBooksResponseError(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return GetBooksResponseError(
        'Error parsing response: $e, data: ${response?.data}',
      );
    }
  }

  Future<GetBookResponse> getBook(String token, String bookId) async {
    const operation = 'bookService_getBook';
    final path = '/books/$bookId';
    Response? response;
    try {
      response = await dio.get(
        path,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (_) => true,
        ),
      );
      if (response.statusCode == 200) {
        final book = Book.fromJson(response.data as Map<String, dynamic>);
        return GetBookSuccess(book);
      } else if (response.statusCode == 401) {
        return GetBookUnauthorized();
      } else if (response.statusCode == 404) {
        return GetBookNotFound();
      } else {
        Logger.log(
          'Failed to get book: ${response.statusCode} ${response.statusMessage}',
          operation: operation,
        );
        return GetBookError(
          '${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return GetBookError(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return GetBookError(
        'Error parsing response: $e, data: ${response?.data}',
      );
    }
  }

  Future<AddBookResponse> addBook(String token, AddBookRequest book) async {
    const operation = 'bookService_addBook';
    const path = '/books';
    Response? response;
    try {
      response = await dio.post(
        path,
        data: book.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (_) => true,
        ),
      );
      if (response.statusCode == 201) {
        final newBook = Book.fromJson(response.data as Map<String, dynamic>);
        return AddedSuccessfully(newBook);
      } else if (response.statusCode == 401) {
        return AddBookUnauthorized();
      } else if (response.statusCode == 409) {
        return Conflict();
      } else {
        Logger.log(
          'Failed to add book: ${response.statusCode} ${response.statusMessage}',
          operation: operation,
        );
        return AddBookError(
          '${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return AddBookError(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return AddBookError(
        'Error parsing response: $e, data: ${response?.data}',
      );
    }
  }

  Future<UpdateBookResponse> updateBook(String token, Book book) async {
    const operation = 'bookService_updateBook';
    final path = '/books/${book.id}';
    Response? response;
    try {
      response = await dio.put(
        path,
        data: book.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (_) => true,
        ),
      );
      if (response.statusCode == 200) {
        final updatedBook =
            Book.fromJson(response.data as Map<String, dynamic>);
        return Success(updatedBook);
      } else if (response.statusCode == 401) {
        return Unauthorized();
      } else {
        Logger.log(
          'Failed to update book: ${response.statusCode} ${response.statusMessage}',
          operation: operation,
        );
        return UpdateError(
          '${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return UpdateError(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return UpdateError(
        'Error parsing response: $e, data: ${response?.data}',
      );
    }
  }

  Future<DeleteBookResponse> deleteBook(String token, String bookId) async {
    const operation = 'bookService_deleteBook';
    final path = '/books/$bookId';
    Response? response;
    try {
      response = await dio.delete(
        path,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (_) => true,
        ),
      );
      if (response.statusCode == 204) {
        return DeletedSuccessfully();
      } else if (response.statusCode == 401) {
        return DeleteUnauthorized();
      } else {
        Logger.log(
          'Failed to delete book: ${response.statusCode} ${response.statusMessage}',
          operation: operation,
        );
        return DeleteBookError(
          '${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return DeleteBookError(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return DeleteBookError(
        'Unknown error - response: $e, data: ${response?.data}',
      );
    }
  }
}
