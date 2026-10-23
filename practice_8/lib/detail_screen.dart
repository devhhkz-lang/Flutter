import 'package:flutter/material.dart';

import 'models/book.dart';

// Что пользователь решил на экране деталей
enum BookAction { toggleRead, delete }

// Экран деталей. Получает книгу через конструктор и ОТВЕЧАЕТ списку
// через pop(...). Сам список книг он не трогает.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.book});

  final Book book;

  // Спросить "Удалить?" и только при "Delete" ответить списку
  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete '${book.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false), // диалог отвечает bool
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    // Cancel (false) или тап мимо диалога (null): остаёмся на экране
    if (ok != true) return;

    // Пока ждали диалог, экран мог исчезнуть
    if (!context.mounted) return;
    Navigator.of(context).pop(BookAction.delete);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final yearText =
        book.year == null ? 'Year unknown' : 'Year: ${book.year}';

    return Scaffold(
      // Стрелку "назад" рисует AppBar сам, ничего не добавляем
      appBar: AppBar(title: const Text('Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: text.headlineSmall),
            const SizedBox(height: 8),
            Text(book.author, style: text.titleMedium),
            const SizedBox(height: 16),
            Text('${book.pages} pages'),
            Text(yearText),
            Text(book.read ? 'Status: read' : 'Status: unread'),
            const SizedBox(height: 24),

            // Подпись кнопки зависит от book.read
            FilledButton(
              onPressed: () => Navigator.of(context).pop(BookAction.toggleRead),
              child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _confirmDelete(context),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}