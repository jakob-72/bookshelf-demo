import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/pages/book_detail_page/state.dart';
import 'package:state_notifier/state_notifier.dart';

class BookDetailPageModel extends StateNotifier<BookDetailPageState>
    with LocatorMixin {
  BookDetailPageModel(Book book) : super(Idle(book));
}
