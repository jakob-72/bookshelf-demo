import 'package:bookshelf_app/shared/styles.dart';
import 'package:flutter/material.dart';

class DeleteBookDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteBookDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Delete Book'),
    content: const Text('Are you sure you want to delete this book?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          onConfirm();
          Navigator.of(context).pop();
        },
        style: deleteButton,
        child: const Text('Delete'),
      ),
    ],
  );
}
