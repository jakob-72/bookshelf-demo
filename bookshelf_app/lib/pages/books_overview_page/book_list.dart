import 'package:bookshelf_app/data/models/book.dart';
import 'package:flutter/material.dart';

class BookList extends StatelessWidget {
  final List<Book> books;

  const BookList({super.key, required this.books});

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) {
          if (books.isEmpty) {
            return const Text('No books found');
          }
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) => BookListItem(book: books[index]),
          );
        },
      );
}

class BookListItem extends StatelessWidget {
  final Book book;

  const BookListItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) => Text(book.title);
}
