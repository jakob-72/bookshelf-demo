import 'package:auto_route/annotations.dart';
import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/pages/book_detail_page/book_detail_page_model.dart';
import 'package:bookshelf_app/pages/book_detail_page/delete_book_dialog.dart';
import 'package:bookshelf_app/pages/book_detail_page/state.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';
import 'package:bookshelf_app/shared/extensions.dart';
import 'package:bookshelf_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

@RoutePage()
class BookDetailPage extends StatelessWidget {
  final String bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) =>
      StateNotifierProvider<BookDetailPageModel, BookDetailPageState>(
        create: (context) => BookDetailPageModel(bookId),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Book Details', style: headline2),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.read<AppRouter>().pushAndPopUntil(
                    const BookOverviewRoute(),
                    predicate: (_) => true,
                  ),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: BookDetailBody(bookId: bookId),
              ),
            ),
          ),
        ),
      );
}

class BookDetailBody extends StatefulWidget {
  final String bookId;

  const BookDetailBody({super.key, required this.bookId});

  @override
  State<BookDetailBody> createState() => _BookDetailBodyState();
}

class _BookDetailBodyState extends State<BookDetailBody> {
  late Book book;

  @override
  void initState() {
    context.read<BookDetailPageModel>().reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BookDetailPageState>();
    if (state is Loading) {
      return const CircularProgressIndicator();
    } else if (state is Idle) {
      setState(() => book = state.book);
    } else if (state is Error) {
      context.showSnackbar(state.message);
    }
    return BookDetailForm(book: book);
  }
}

class BookDetailForm extends StatefulWidget {
  final Book book;

  const BookDetailForm({super.key, required this.book});

  @override
  State<BookDetailForm> createState() => _BookDetailFormState();
}

class _BookDetailFormState extends State<BookDetailForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _genreController;
  late TextEditingController _ratingController;

  late bool _read;

  BookDetailPageModel get model => context.read<BookDetailPageModel>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _genreController = TextEditingController(text: widget.book.genre);
    _ratingController =
        TextEditingController(text: widget.book.rating?.toString());
    _read = widget.book.read;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            TextFormField(
              controller: _genreController,
              decoration: const InputDecoration(labelText: 'Genre'),
            ),
            TextFormField(
              controller: _ratingController,
              decoration: const InputDecoration(labelText: 'Rating'),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              title: const Text('Read'),
              value: _read,
              onChanged: (bool value) {
                setState(() => _read = value);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final newBook = Book(
                      id: widget.book.id,
                      title: _titleController.text,
                      author: _authorController.text,
                      genre: _genreController.text,
                      rating: int.tryParse(_ratingController.text),
                      read: _read,
                    );
                    model.saveBook(newBook);
                  },
                  style: primaryButton,
                  child: const Text('Save Changes'),
                ),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DeleteBookDialog(
                      onConfirm: () => model.deleteBook(),
                    ),
                  ),
                  style: deleteButton,
                  child: const Text('Delete Book'),
                ),
              ],
            ),
          ],
        ),
      );
}
