import 'package:bookshelf_app/data/book_service.dart';
import 'package:bookshelf_app/data/local_storage.dart';

class CheckTokenUseCase {
  final LocalStorage storage;
  final BookService bookService;

  CheckTokenUseCase({required this.storage, required this.bookService});

  Future<bool> hasValidToken() async {
    final token = await storage.token;
    if (token == null) {
      return false;
    }

    return bookService.checkToken(token);
  }
}
