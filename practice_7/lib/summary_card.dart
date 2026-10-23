import 'package:flutter/material.dart';

// Карточка с итогом регистрации.
// StatelessWidget: ничего не хранит, только показывает то, что ей передали.
// Она не знает, на каком экране находится, и спрашивает только про свою ширину.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.name,
    required this.email,
    required this.group,
    required this.birth,
  });

  final String name;
  final String email;
  final String group;
  final String birth;

  @override
  Widget build(BuildContext context) {
    // Четыре плитки: по одной ListTile на каждое значение
    final tiles = [
      ListTile(
        leading: const Icon(Icons.person),
        title: Text(name),
        subtitle: const Text('Name'),
      ),
      ListTile(
        leading: const Icon(Icons.email),
        title: Text(email),
        subtitle: const Text('Email'),
      ),
      ListTile(
        leading: const Icon(Icons.group),
        title: Text(group),
        subtitle: const Text('Group'),
      ),
      ListTile(
        leading: const Icon(Icons.cake),
        title: Text(birth),
        subtitle: const Text('Date of birth'),
      ),
    ];

    return Card(
      // LayoutBuilder (а не MediaQuery): узнаём ширину самой карточки,
      // а не всего экрана.
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            // Широко -> две колонки
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 4,
              // Прокручивает внешний SingleChildScrollView, а не сетка
              physics: const NeverScrollableScrollPhysics(),
              children: tiles,
            );
          }
          // Узко -> одна колонка
          return Column(children: tiles);
        },
      ),
    );
  }
}