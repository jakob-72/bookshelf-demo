import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/get_books_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';

class GetBooksUseCase {
  final LocalStorage storage;
  final BookService bookService;

  GetBooksUseCase({required this.storage, required this.bookService});

  Future<GetBooksResponse> getBooks({String? searchTerm}) async {
    final token = await storage.token;
    if (token == null) {
      return GetBooksResponse.unauthorized();
    }
    return bookService.getBooks(token, searchTerm);
  }
}
