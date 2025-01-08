import 'package:auto_route/annotations.dart';
import 'package:bookshelf_app/pages/books_overview_page/add_book_dialog.dart';
import 'package:bookshelf_app/pages/books_overview_page/book_list.dart';
import 'package:bookshelf_app/pages/books_overview_page/book_overview_page_model.dart';
import 'package:bookshelf_app/pages/books_overview_page/search_dialog.dart';
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
  Widget build(BuildContext context) =>
      StateNotifierProvider<BookOverviewPageModel, BooksOverviewPageState>(
        create: (_) => BookOverviewPageModel(),
        builder: (context, _) {
          final state = context.watch<BooksOverviewPageState>();
          return Scaffold(
              appBar: AppBar(
                title: const Text('My Books', style: headline1),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    onPressed: () =>
                        context.read<BookOverviewPageModel>().refresh(),
                  ),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => SearchDialog(
                        model: context.read<BookOverviewPageModel>(),
                      ),
                    ),
                    tooltip: 'Search',
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: () =>
                        context.read<BookOverviewPageModel>().logout(),
                  ),
                ],
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 800,
                    ),
                    child: BookOverviewBody(state: state),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (state is Loading) {
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (_) => AddBookDialog(
                      model: context.read<BookOverviewPageModel>(),
                    ),
                  );
                },
                tooltip: 'Add a book',
                child: const Icon(Icons.add),
              ));
        },
      );
}

class BookOverviewBody extends StatelessWidget {
  final BooksOverviewPageState state;

  const BookOverviewBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) {
          final model = context.read<BookOverviewPageModel>();
          final books = state.books;

          if (state is Loading) {
            return const CircularProgressIndicator();
          }
          if (state is Error) {
            context.showSnackbar((state as Error).message);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('An error occurred'),
                const Gap(16),
                ElevatedButton(
                  onPressed: () => model.refresh(),
                  style: primaryButton,
                  child: const Text('Retry'),
                ),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SearchLabel(
                  searchTerm: (state as Idle).searchTerm, model: model),
              if ((state as Idle).searchTerm != null) const Gap(16),
              Expanded(
                child: BookList(
                  books: books,
                ),
              ),
            ],
          );
        },
      );
}

class _SearchLabel extends StatelessWidget {
  final BookOverviewPageModel model;
  final String? searchTerm;

  const _SearchLabel({required this.model, this.searchTerm});

  @override
  Widget build(BuildContext context) {
    if (searchTerm == null || searchTerm!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(searchTerm!),
          const SizedBox(width: 4),
          InkWell(
            onTap: () => model.refresh(),
            child: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
    );
  }
}
