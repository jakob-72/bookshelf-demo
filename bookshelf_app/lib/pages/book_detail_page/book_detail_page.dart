import 'package:auto_route/annotations.dart';
import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/pages/book_detail_page/book_detail_page_model.dart';
import 'package:bookshelf_app/pages/book_detail_page/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

@RoutePage()
class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) =>
      StateNotifierProvider<BookDetailPageModel, BookDetailPageState>(
        create: (context) => BookDetailPageModel(book),
        child: Scaffold(
          appBar: AppBar(
            title: Text(book.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(book.title),
                Text(book.author),
              ],
            ),
          ),
        ),
      );
}
