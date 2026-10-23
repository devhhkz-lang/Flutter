import 'package:flutter/material.dart';

import '../models/book.dart';

// Карточка одной книги. Ничего не хранит: получает книгу и функцию-реакцию.
// Все цвета берём из colorScheme, все стили из textTheme
// (без Colors.* и без fontSize).
class BookTile extends StatelessWidget {
  const BookTile({
    super.key,
    required this.book,
    required this.onToggle,
  });

  final Book book;
  final VoidCallback onToggle; // вызываем, когда нажали на галочку

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Слева: кружок с первой буквой и точка "не прочитано"
            Stack(
              children: [
                CircleAvatar(
                  child: Text(
                    book.title.isEmpty ? '?' : book.title.substring(0, 1),
                  ),
                ),
                if (!book.read)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Середина: Expanded отдаёт тексту всю оставшуюся ширину.
            // Без него длинное название растянуло бы Row и вышла бы ошибка overflow.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: text.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${book.author} · ${book.pages} pp.',
                    style: text.bodySmall,
                  ),
                ],
              ),
            ),

            // Справа: галочка. Сама ничего не меняет, только вызывает onToggle.
            Checkbox(
              value: book.read,
              onChanged: (_) => onToggle(),
            ),
          ],
        ),
      ),
    );
  }
}