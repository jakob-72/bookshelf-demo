import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/dto/add_book_request.dart';
import 'package:bookshelf_app/data/dto/add_book_response.dart';
import 'package:bookshelf_app/data/local_storage.dart';

class AddBookUseCase {
  final BookService bookService;
  final LocalStorage storage;

  AddBookUseCase({required this.bookService, required this.storage});

  Future<AddBookResponse> addBook({
    required String title,
    required String author,
    String? genre,
    int? rating,
    bool read = false,
  }) async {
    final token = await storage.token;
    if (token == null) {
      return AddBookUnauthorized();
    }
    final book = AddBookRequest(
      title: title,
      author: author,
      genre: genre,
      rating: rating,
      read: read,
    );
    return bookService.addBook(token, book);
  }
}
