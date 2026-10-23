// Это чистый Dart: здесь НЕТ импорта Flutter.

class Book {
  // Обычный конструктор: year необязательный (int?), read по умолчанию false
  Book({
    required this.title,
    required this.author,
    required this.pages,
    this.year,
    this.read = false,
  });

  // Именованный конструктор: собирает Book из Map.
  // title, author, pages обязательны.
  // year: если ключа нет, m['year'] вернёт null, и это нормально для int?.
  // read: если ключа нет, берём false (оператор ?? даёт запасное значение).
  Book.fromMap(Map<String, dynamic> m)
      : title = m['title'] as String,
        author = m['author'] as String,
        pages = m['pages'] as int,
        year = m['year'] as int?,
        read = m['read'] as bool? ?? false;

  final String title;
  final String author;
  final int pages;
  final int? year; // "?" значит: года может не быть
  bool read; // не final, потому что галочка меняет его

  // Пример: "Null Safety for Humans — B. Seitkali, 196 pp. (2022)"
  // Если года нет, скобки не печатаем вообще.
  @override
  String toString() {
    final y = year == null ? '' : ' ($year)';
    return '$title — $author, $pages pp.$y';
  }
}

// Сумма страниц всех книг. fold начинает с 0 и прибавляет страницы каждой книги.
int totalPages(List<Book> books) =>
    books.fold<int>(0, (sum, b) => sum + b.pages);

// Только непрочитанные. where оставляет нужные, toList() собирает в список.
List<Book> unread(List<Book> books) =>
    books.where((b) => !b.read).toList();

// Авторы без повторов, порядок сохраняется.
// map берёт автора, toSet убирает дубли, toList возвращает список.
List<String> authors(List<Book> books) =>
    books.map((b) => b.author).toSet().toList();

// Начальные данные. На них никто не пишет: экран делает копию.
final seed = <Book>[
  Book(
      title: 'Widgets All the Way Down',
      author: 'A. Nurmagambetova',
      pages: 288,
      year: 2021,
      read: true),
  Book(
      title: 'Null Safety for Humans',
      author: 'B. Seitkali',
      pages: 196,
      year: 2022),
  Book(
      title: 'Constraints Go Down, Sizes Go Up',
      author: 'C. Tashimova',
      pages: 320),
  Book(
      title: 'The Navigator Is a Stack',
      author: 'D. Alibekov',
      pages: 240,
      year: 2020),
  Book(
      title: 'A Very Long Title About Forms, Focus, the Keyboard '
          'and Everything That Overflows',
      author: 'E. Omarova',
      pages: 176,
      year: 2023),
];