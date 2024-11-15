import 'package:flutter/material.dart';

const headline1 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.grey,
);

final buttonText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.grey[800],
);

InputDecoration inputDecoration(String label, {bool required = false}) =>
    InputDecoration(
      label: Row(
        children: [
          Text(label),
          if (required)
            const Text(
              ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
      hintText: label,
      labelStyle: const TextStyle(color: Colors.white),
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Colors.grey[350]),
      focusColor: Colors.grey[400],
      hoverColor: Colors.grey[400],
    );
