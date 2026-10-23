import 'package:flutter/material.dart';

import 'library_screen.dart';
import 'models/book.dart';

void main() {
  // Level 1: проверка Dart-кода до запуска приложения.
  // Ожидаем в консоли: "1220 pages, 4 unread" и "X — Y, 10 pp."
  debugPrint('${totalPages(seed)} pages, ${unread(seed).length} unread');
  debugPrint(
    Book.fromMap({'title': 'X', 'author': 'Y', 'pages': 10}).toString(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const LibraryScreen(),
      );
}