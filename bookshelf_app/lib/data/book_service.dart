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
        return GetBooksResponse.success(books);
      } else if (response.statusCode == 401) {
        return GetBooksResponse.unauthorized();
      } else {
        Logger.log(
          'Failed to get books: ${response.statusCode} ${response.statusMessage}',
          operation: operation,
        );
        return GetBooksResponse.error(
          '${response.statusCode}: ${response.data}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return GetBooksResponse.error(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return GetBooksResponse.error(
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
        return GetBookResponse.success(book);
      } else if (response.statusCode == 401) {
        return GetBookResponse.unauthorized();
      } else if (response.statusCode == 404) {
        return GetBookResponse.notFound();
      } else {
        Logger.log(
          'Failed to get book: ${response.statusCode} ${response.statusMessage}',
          operation: operation,
        );
        return GetBookResponse.error(
          '${response.statusCode}: ${response.data}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return GetBookResponse.error(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return GetBookResponse.error(
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
        return AddBookResponse.success(newBook);
      } else if (response.statusCode == 401) {
        return AddBookResponse.unauthorized();
      } else if (response.statusCode == 409) {
        return AddBookResponse.conflict();
      } else {
        Logger.log(
          'Failed to add book: ${response.statusCode}: ${response.statusMessage}',
          operation: operation,
        );
        return AddBookResponse.error(
          '${response.statusCode}: ${response.data}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return AddBookResponse.error(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return AddBookResponse.error(
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
        return UpdateBookResponse.success(updatedBook);
      } else if (response.statusCode == 401) {
        return UpdateBookResponse.unauthorized();
      } else if (response.statusCode == 404) {
        return UpdateBookResponse.notFound();
      } else {
        Logger.log(
          'Failed to update book: ${response.statusCode} ${response.statusMessage}',
          operation: operation,
        );
        return UpdateBookResponse.error(
          '${response.statusCode}: ${response.data}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return UpdateBookResponse.error(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return UpdateBookResponse.error(
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
        return DeleteBookResponse.success();
      } else if (response.statusCode == 401) {
        return DeleteBookResponse.unauthorized();
      } else if (response.statusCode == 404) {
        return DeleteBookResponse.notFound();
      } else {
        Logger.log(
          'Failed to delete book: ${response.statusCode} ${response.statusMessage}',
          operation: operation,
        );
        return DeleteBookResponse.error(
          '${response.statusCode}: ${response.data}',
        );
      }
    } on DioException catch (e) {
      Logger.logError(e, operation: operation);
      return DeleteBookResponse.error(e.message ?? 'Internal error');
    } catch (e) {
      Logger.logError(e, operation: operation);
      return DeleteBookResponse.error(
        'Unknown error - response: $e, data: ${response?.data}',
      );
    }
  }
}
