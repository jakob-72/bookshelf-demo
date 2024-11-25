import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/update_book_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';
import 'package:bookshelf_app/data/models/book.dart';

class UpdateBookUseCase {
  final LocalStorage storage;
  final BookService bookService;

  UpdateBookUseCase({required this.storage, required this.bookService});

  Future<UpdateBookResponse> updateBook(Book book) async {
    final token = await storage.token;
    if (token == null) {
      return Unauthorized();
    }
    return bookService.updateBook(token, book);
  }
}
