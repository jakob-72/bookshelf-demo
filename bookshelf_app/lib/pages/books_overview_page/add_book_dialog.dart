import 'package:bookshelf_app/pages/books_overview_page/book_overview_page_model.dart';
import 'package:bookshelf_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class AddBookDialog extends StatefulWidget {
  static const titleKey = Key('title');
  static const authorKey = Key('author');
  static const genreKey = Key('genre');
  static const ratingKey = Key('rating');
  static const submitKey = Key('submit');

  final BookOverviewPageModel model;

  const AddBookDialog({super.key, required this.model});

  @override
  State<AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();
  final _ratingController = TextEditingController();

  bool _read = false;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text(
          'Add New Book',
          style: headline2,
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: AddBookDialog.titleKey,
                controller: _titleController,
                decoration: inputDecoration('Title', required: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              const Gap(16),
              TextFormField(
                key: AddBookDialog.authorKey,
                controller: _authorController,
                decoration: inputDecoration('Author', required: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author';
                  }
                  return null;
                },
              ),
              const Gap(16),
              TextFormField(
                key: AddBookDialog.genreKey,
                controller: _genreController,
                decoration: inputDecoration('Genre'),
              ),
              const Gap(16),
              TextFormField(
                key: AddBookDialog.ratingKey,
                controller: _ratingController,
                decoration: inputDecoration('Rating'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  final rating = int.tryParse(value);
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'Please enter a valid rating between 0 and 5';
                  }
                  return null;
                },
              ),
              const Gap(16),
              Row(
                children: [
                  const Text('Read', style: TextStyle(color: Colors.grey)),
                  Checkbox(
                    value: _read,
                    onChanged: (bool? value) =>
                        setState(() => _read = value ?? false),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => widget.model.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            key: AddBookDialog.submitKey,
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              widget.model.addBook(
                title: _titleController.text,
                author: _authorController.text,
                genre: _genreController.text,
                rating: int.tryParse(_ratingController.text),
                read: _read,
              );
              widget.model.pop();
            },
            style: primaryButton,
            child: const Text('Submit'),
          ),
        ],
      );

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _ratingController.dispose();
    super.dispose();
  }
}
