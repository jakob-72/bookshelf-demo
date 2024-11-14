import 'package:auto_route/annotations.dart';
import 'package:bookshelf_app/pages/books_overview_page/book_overview_page_model.dart';
import 'package:bookshelf_app/shared/styles.dart';
import 'package:flutter/material.dart';
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
          body: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Booklist"),
            ),
          ),
        ),
      );
}
