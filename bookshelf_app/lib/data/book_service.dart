import 'package:bookshelf_app/data/dto/get_books_response.dart';
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
}
