import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/get_book_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';

class GetBookUseCase {
  final LocalStorage storage;
  final BookService bookService;

  GetBookUseCase({required this.storage, required this.bookService});

  Future<GetBookResponse> getBook(String bookId) async {
    final token = await storage.token;
    if (token == null) {
      return GetBookResponse.unauthorized();
    }
    return bookService.getBook(token, bookId);
  }
}
