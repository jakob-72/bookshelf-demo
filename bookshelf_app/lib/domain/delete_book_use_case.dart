import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/delete_book_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';

class DeleteBookUseCase {
  final LocalStorage storage;
  final BookService bookService;

  DeleteBookUseCase({required this.storage, required this.bookService});

  Future<DeleteBookResponse> deleteBook(String bookId) async {
    final token = await storage.token;
    if (token == null) {
      return DeleteBookResponse.unauthorized();
    }
    return bookService.deleteBook(token, bookId);
  }
}
