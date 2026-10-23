import 'package:flutter/material.dart';

import 'add_book_screen.dart';
import 'detail_screen.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';

// Три режима фильтра
enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // Состояние экрана: список книг и текущий фильтр.
  // [...seed] это КОПИЯ, так что исходный seed никто не портит.
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  // Какие книги показывать сейчас (switch expression по фильтру)
  List<Book> get _visible => switch (_filter) {
        Filter.all => _books,
        Filter.unread => unread(_books),
        Filter.read => _books.where((b) => b.read).toList(),
      };

  // Подпись для чипа
  String _label(Filter f) => switch (f) {
        Filter.all => 'All',
        Filter.unread => 'Unread',
        Filter.read => 'Read',
      };

  // Level 4: открыть детали и дождаться ответа (await).
  // Детали сами ничего не меняют, они только отвечают.
  Future<void> _openDetail(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(builder: (_) => DetailScreen(book: book)),
    );

    // Пока ждали, экран мог исчезнуть: проверяем mounted
    if (!mounted) return;

    switch (action) {
      case null:
        break; // нажали "назад": ничего не меняем
      case BookAction.toggleRead:
        setState(() => book.read = !book.read);
      case BookAction.delete:
        setState(() => _books.remove(book));
    }
  }

  // Level 5: открыть форму и дождаться новой книги
  Future<void> _addBook() async {
    final book = await Navigator.of(context).push<Book>(
      MaterialPageRoute(builder: (_) => const AddBookScreen()),
    );

    if (book == null) return; // нажали "назад": ничего не добавляем
    if (!mounted) return;
    setState(() => _books.add(book));
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible; // считаем один раз за перерисовку

    return Scaffold(
      appBar: AppBar(title: Text('Reading list (${visible.length})')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            // Шапка: три равные колонки (Expanded делит ширину поровну)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: _Stat(value: _books.length, label: 'Books'),
                    ),
                    Expanded(
                      child: _Stat(value: totalPages(_books), label: 'Pages'),
                    ),
                    Expanded(
                      child: _Stat(
                        value: unread(_books).length,
                        label: 'Unread',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Три чипа-фильтра
            Row(
              children: [
                for (final f in Filter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_label(f)),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),

            // Список занимает всё оставшееся место
            Expanded(
              child: ListView.builder(
                itemCount: visible.length,
                itemBuilder: (context, i) {
                  final book = visible[i];
                  return InkWell(
                    onTap: () => _openDetail(book),
                    child: BookTile(
                      book: book,
                      onToggle: () => setState(() => book.read = !book.read),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Одна колонка шапки: число сверху, подпись снизу
class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Text('$value', style: text.headlineSmall),
        Text(label, style: text.bodySmall),
      ],
    );
  }
}