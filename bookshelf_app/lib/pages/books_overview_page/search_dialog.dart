import 'package:bookshelf_app/pages/books_overview_page/book_overview_page_model.dart';
import 'package:bookshelf_app/shared/styles.dart';
import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  static const searchKey = Key('search');

  final BookOverviewPageModel model;

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  SearchDialog({super.key, required this.model});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text(
          'Search Books',
          style: headline2,
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            key: searchKey,
            controller: _searchController,
            decoration: inputDecoration('Search Term', required: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a search term';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => model.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              model.refresh(searchTerm: _searchController.text);
              model.pop();
            },
            style: primaryButton,
            child: const Text('Search'),
          ),
        ],
      );
}
