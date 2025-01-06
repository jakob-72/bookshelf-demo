import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/pages/books_overview_page/book_overview_page_model.dart';
import 'package:bookshelf_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookList extends StatelessWidget {
  final List<Book> books;

  const BookList({super.key, required this.books});

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) {
          if (books.isEmpty) {
            return const Text('No books found');
          }
          return ListView.separated(
            itemCount: books.length,
            itemBuilder: (context, index) => BookListItem(book: books[index]),
            separatorBuilder: (context, _) => const Divider(),
          );
        },
      );
}

class BookListItem extends StatelessWidget {
  final Book book;

  const BookListItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(
          book.title,
          style: headline3,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              book.author,
              style: subtitle1,
            ),
            if (book.genre != null && book.genre!.isNotEmpty)
              Text(book.genre!, style: subtitle2)
            else
              const SizedBox.shrink(),
            _buildRating(),
          ],
        ),
        trailing: book.read
            ? const Icon(
                Icons.check,
                color: Colors.green,
                size: 24,
              )
            : const SizedBox(
                width: 24,
                height: 24,
              ),
        onTap: () => context
            .read<BookOverviewPageModel>()
            .navigateToBookDetailPage(book.id),
      );

  Row _buildRating() {
    final List<Icon> icons = [];
    final rating = book.rating ?? 0;
    for (var i = 0; i <= 4; i++) {
      if (i < rating) {
        icons.add(const Icon(
          Icons.star,
          color: Colors.orange,
          size: 16,
        ));
      } else {
        icons.add(const Icon(
          Icons.star_border_outlined,
          color: Colors.orange,
          size: 16,
        ));
      }
    }
    return Row(children: icons);
  }
}
