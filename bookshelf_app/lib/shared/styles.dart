import 'package:flutter/material.dart';

const headline1 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const headline2 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const headline3 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

final subtitle1 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

final subtitle2 = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

final primaryButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  shadowColor: Colors.black54,
  elevation: 5,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
);

final deleteButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  foregroundColor: Colors.white,
  shadowColor: Colors.black54,
  elevation: 5,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
);

final secondaryButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey[600],
  foregroundColor: Colors.white,
  shadowColor: Colors.black45,
  elevation: 3,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
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
      labelStyle: TextStyle(color: Colors.grey[850]),
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Colors.grey[800]),
      focusColor: Colors.grey[850],
      hoverColor: Colors.grey[850],
    );
