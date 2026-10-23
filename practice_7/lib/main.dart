import 'package:flutter/material.dart';

import 'summary_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: const SignUpScreen(),
      );
}

// Список групп для выпадающего списка (Level 4)
const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // =================================================================
  // ВСЁ, ЧТО ИМЕЕТ dispose(), И ВСЁ СОСТОЯНИЕ ЭКРАНА ЖИВЁТ ЗДЕСЬ.
  // Создаётся один раз. Никогда не создаём это внутри build().
  // =================================================================

  // Level 2: ключ формы. Через него вызываем validate().
  final _formKey = GlobalKey<FormState>();

  // Контроллеры текстовых полей
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthText = TextEditingController(); // текст даты "dd.mm.yyyy"

  // Level 3: FocusNode для Email (чтобы Name мог передать ему фокус)
  final _emailFocus = FocusNode();

  // Level 1: длина пароля для подписи "3 of 8"
  int _passwordLength = 0;

  // Level 4: значения, которые не являются текстом
  String? _group; // выбранная группа (null = не выбрана)
  DateTime? _birth; // выбранная дата (null = не выбрана)
  bool _agreed = false; // галочка "I agree"

  // Level 5: false -> показываем форму, true -> показываем итог
  bool _done = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm, _birthText]) {
      c.dispose();
    }
    _emailFocus.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------
  // Вспомогательные методы
  // ---------------------------------------------------------------

  // Level 3: тап по пустому фону прячет клавиатуру
  void _hideKeyboard(PointerDownEvent event) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Показать сообщение внизу экрана
  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  // Дата -> строка dd.mm.yyyy (padLeft добавляет ведущий ноль: 5 -> 05)
  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day.$month.${d.year}';
  }

  // ---------------------------------------------------------------
  // Level 2: правила проверки. Каждое лежит рядом со своим полем.
  // Правило: вернули null -> всё хорошо, вернули строку -> это ошибка.
  // Параметр String? может быть null, поэтому пишем (v ?? '').
  // ---------------------------------------------------------------

  String? _validateName(String? v) {
    final name = (v ?? '').trim();
    return name.length < 2 ? 'Name is too short' : null;
  }

  String? _validateEmail(String? v) {
    final email = (v ?? '').trim();
    final at = email.indexOf('@'); // позиция @ (или -1, если её нет)
    // Нужна @ не в начале и точка где-то после неё
    if (at < 1 || !email.substring(at).contains('.')) {
      return 'Email looks wrong';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    final password = v ?? '';
    return password.length < 8 ? 'Password is too short' : null;
  }

  // Этот validator читает ДРУГОЙ контроллер (_password)
  String? _validateConfirm(String? v) {
    return (v ?? '') != _password.text ? 'Passwords do not match' : null;
  }

  // ---------------------------------------------------------------
  // Level 2 + 5: нажатие "Sign up"
  // ---------------------------------------------------------------
  void _signUp() {
    // Единственный разрешённый "!" в проекте: к моменту нажатия кнопки
    // Form уже построена, значит currentState не null.
    if (_formKey.currentState!.validate()) {
      _showMessage('Account created');
      setState(() => _done = true); // Level 5: показать итог
    }
  }

  // ---------------------------------------------------------------
  // Level 4: выбор даты рождения
  // ---------------------------------------------------------------
  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    // Три строки после диалога:
    if (picked == null) return; // 1) нажали Cancel -> старая дата остаётся
    if (!mounted) return; // 2) экран мог исчезнуть, пока был открыт диалог
    setState(() {
      // 3) сохраняем дату и пишем её в поле
      _birth = picked;
      _birthText.text = _formatDate(picked);
    });
  }

  // ---------------------------------------------------------------
  // Level 5: "Start over" — вернуть всё к начальным значениям.
  // Здесь НЕЛЬЗЯ трогать _formKey.currentState: Form сейчас не на экране,
  // там null, и "!" упал бы с ошибкой.
  // ---------------------------------------------------------------
  void _startOver() {
    setState(() {
      for (final c in [_name, _email, _password, _confirm, _birthText]) {
        c.clear();
      }
      _passwordLength = 0;
      _group = null;
      _birth = null;
      _agreed = false;
      _done = false;
    });
  }

  // ---------------------------------------------------------------
  // Экран
  // ---------------------------------------------------------------

  // Форма регистрации
  Widget _buildForm() => Form(
        key: _formKey,
        // Ошибки появляются, когда пользователь уже трогал поле
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // --- Name ---
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              textInputAction: TextInputAction.next,
              validator: _validateName,
              // Конкретная цель фокуса: поле Email
              onFieldSubmitted: (_) => _emailFocus.requestFocus(),
              onTapOutside: _hideKeyboard,
            ),
            const SizedBox(height: 12),

            // --- Email ---
            TextFormField(
              controller: _email,
              focusNode: _emailFocus,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@kbtu.kz',
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
              onTapOutside: _hideKeyboard,
            ),
            const SizedBox(height: 12),

            // --- Password ---
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'Password',
                helperText: 'At least 8 characters',
              ),
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: _validatePassword,
              // value in, onChanged out, setState closes the loop
              onChanged: (value) => setState(() {
                _passwordLength = value.length;
              }),
              onTapOutside: _hideKeyboard,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('$_passwordLength of 8'),
            ),
            const SizedBox(height: 12),

            // --- Confirm password ---
            TextFormField(
              controller: _confirm,
              decoration: const InputDecoration(labelText: 'Confirm password'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: _validateConfirm,
              // Клавиша "done" делает то же, что кнопка.
              // Кнопка выключена без галочки, поэтому и здесь проверяем её.
              onFieldSubmitted: (_) {
                if (_agreed) _signUp();
              },
              onTapOutside: _hideKeyboard,
            ),
            const SizedBox(height: 12),

            // --- Group (выпадающий список) ---
            DropdownButtonFormField<String>(
              initialValue: _group,
              decoration: const InputDecoration(labelText: 'Group'),
              // коллекция for: из списка строк делаем список пунктов меню
              items: [
                for (final g in groups)
                  DropdownMenuItem(value: g, child: Text(g)),
              ],
              onChanged: (g) => setState(() => _group = g),
              validator: (g) => g == null ? 'Choose a group' : null,
            ),
            const SizedBox(height: 12),

            // --- Date of birth (поле только для чтения + календарь) ---
            TextFormField(
              controller: _birthText,
              readOnly: true, // печатать нельзя, только выбрать
              decoration: const InputDecoration(
                labelText: 'Date of birth',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: _pickBirthDate,
              validator: (_) => _birth == null ? 'Choose a date' : null,
            ),
            const SizedBox(height: 12),

            // --- Checkbox ---
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('I agree to the rules'),
              value: _agreed,
              onChanged: (v) => setState(() => _agreed = v ?? false),
            ),

            // Между последним полем и кнопкой — SizedBox, а не Spacer
            // (Spacer внутри прокручиваемого экрана вызывает ошибку)
            const SizedBox(height: 24),

            // onPressed: null -> кнопка серая и не нажимается.
            // Никакого if внутри обработчика не нужно.
            FilledButton(
              onPressed: _agreed ? _signUp : null,
              child: const Text('Sign up'),
            ),
          ],
        ),
      );

  // Итоговый экран после успешной регистрации
  Widget _buildSummary() => Column(
        children: [
          SummaryCard(
            name: _name.text,
            email: _email.text,
            group: _group ?? '',
            birth: _birthText.text,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _startOver,
            child: const Text('Start over'),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Sign up')),
        // SingleChildScrollView: форма прокручивается, клавиатура не ломает экран
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _done ? _buildSummary() : _buildForm(),
        ),
      );
}