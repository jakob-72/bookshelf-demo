import 'package:auto_route/annotations.dart';
import 'package:bookshelf_app/pages/books_overview_page/book_list.dart';
import 'package:bookshelf_app/pages/books_overview_page/book_overview_page_model.dart';
import 'package:bookshelf_app/pages/books_overview_page/state.dart';
import 'package:bookshelf_app/shared/extensions.dart';
import 'package:bookshelf_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

@RoutePage()
class BookOverviewPage extends StatelessWidget {
  const BookOverviewPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: const Text('My Books', style: headline1),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: BookOverviewBody(),
          ),
        ),
      );
}

class BookOverviewBody extends StatefulWidget {
  const BookOverviewBody({super.key});

  @override
  State<BookOverviewBody> createState() => _BookOverviewBodyState();
}

class _BookOverviewBodyState extends State<BookOverviewBody> {
  @override
  Widget build(BuildContext context) =>
      StateNotifierProvider<BookOverviewPageModel, BooksOverviewPageState>(
        create: (_) => BookOverviewPageModel(),
        builder: (context, _) {
          final model = context.read<BookOverviewPageModel>();
          final state = context.watch<BooksOverviewPageState>();
          final books = state.books;

          if (state is Loading) {
            return const CircularProgressIndicator();
          }
          if (state is Error) {
            context.showSnackbar(state.message);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('An error occurred'),
                const Gap(16),
                ElevatedButton(
                  onPressed: () => model.refresh(),
                  child: const Text('Retry'),
                ),
              ],
            );
          }
          return BookList(
            books: books,
          );
        },
      );
}
