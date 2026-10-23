import 'package:flutter/material.dart';

import 'models/book.dart';

// Форма добавления книги. Отвечает списку через pop(book).
class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  // Всё, что имеет dispose(), живёт в State и создаётся один раз
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _pages = TextEditingController();
  final _year = TextEditingController();

  @override
  void dispose() {
    for (final c in [_title, _author, _pages, _year]) {
      c.dispose();
    }
    super.dispose();
  }

  // --- Правила: null = всё хорошо, строка = текст ошибки ---

  String? _validateTitle(String? v) =>
      (v ?? '').trim().length < 2 ? 'Title is too short' : null;

  String? _validateAuthor(String? v) =>
      (v ?? '').trim().isEmpty ? 'Author is required' : null;

  String? _validatePages(String? v) {
    final n = int.tryParse((v ?? '').trim());
    if (n == null || n <= 0) return 'A whole number above 0';
    return null;
  }

  // Год можно не указывать. Если указан, то от 1450 до текущего года.
  String? _validateYear(String? v) {
    final text = (v ?? '').trim();
    if (text.isEmpty) return null;
    final n = int.tryParse(text);
    final now = DateTime.now().year;
    if (n == null || n < 1450 || n > now) return 'Year from 1450 to $now';
    return null;
  }

  // Единственный разрешённый "!" в проекте: кнопка внутри построенной формы
  void _save() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        title: _title.text.trim(),
        author: _author.text.trim(),
        // validator уже проверил, что это число, поэтому parse безопасен
        pages: int.parse(_pages.text.trim()),
        // tryParse('') вернёт null: пустой год означает "года нет"
        year: int.tryParse(_year.text.trim()),
      );
      Navigator.of(context).pop(book); // отвечаем списку
    }
  }

  // Тап мимо поля прячет клавиатуру
  void _hideKeyboard(PointerDownEvent event) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Add book')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  validator: _validateTitle,
                  onTapOutside: _hideKeyboard,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _author,
                  decoration: const InputDecoration(labelText: 'Author'),
                  textInputAction: TextInputAction.next,
                  validator: _validateAuthor,
                  onTapOutside: _hideKeyboard,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _pages,
                  decoration: const InputDecoration(labelText: 'Pages'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: _validatePages,
                  onTapOutside: _hideKeyboard,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _year,
                  decoration: const InputDecoration(
                    labelText: 'Year (optional)',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: _validateYear,
                  onFieldSubmitted: (_) => _save(),
                  onTapOutside: _hideKeyboard,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      );
}