import 'package:auto_route/annotations.dart';
import 'package:bookshelf_app/data/dto/get_books_response.dart';
import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/pages/books_overview_page/book_overview_page_model.dart';
import 'package:bookshelf_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

@RoutePage()
class BookOverviewPage extends StatelessWidget {
  const BookOverviewPage({super.key});

  @override
  Widget build(BuildContext context) => Consumer<BookOverviewPageModel>(
        builder: (
          BuildContext context,
          BookOverviewPageModel model,
          Widget? _,
        ) =>
            Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[850],
            title: const Text('My Books', style: headline1),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BookOverviewBody(model: model),
            ),
          ),
        ),
      );
}

class BookOverviewBody extends StatefulWidget {
  final BookOverviewPageModel model;

  const BookOverviewBody({super.key, required this.model});

  @override
  State<BookOverviewBody> createState() => _BookOverviewBodyState();
}

class _BookOverviewBodyState extends State<BookOverviewBody> {
  GetBooksResponse? result;

  _BookOverviewBodyState() {
    widget.model.getBooks().then((result) => setState(() {
          this.result = result;
        }));
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) {
          if (result == null) {
            return const CircularProgressIndicator();
          }
          if (result is GetBooksResponseUnauthorized) {
            widget.model.navigateToLoginPage();
          }
          if (result is GetBooksResponseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text((result as GetBooksResponseError).message),
                duration: const Duration(seconds: 5),
              ),
            );
            return Column(
              children: [
                const Text('An error occurred'),
                const Gap(16),
                ElevatedButton(
                  onPressed: () async {
                    setState(() => result = null);
                    final res = await widget.model.getBooks();
                    setState(() => result = res);
                  },
                  child: const Text('Retry'),
                ),
              ],
            );
          }
          if (result is GetBooksResponseSuccess) {
            return BookList(books: (result as GetBooksResponseSuccess).books);
          }
          return const SizedBox.shrink();
        },
      );
}

class BookList extends StatelessWidget {
  final List<Book> books;

  const BookList({super.key, required this.books});

  @override
  Widget build(BuildContext context) => const Text("TODO: BookList");
}
