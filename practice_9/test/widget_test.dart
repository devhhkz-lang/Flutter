import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:practice_9/main.dart';
import 'package:practice_9/models/cart.dart';

void main() {
  testWidgets('Add marks the book as Added and updates the badge',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(create: (_) => Cart(), child: const Shell()),
    );

    expect(find.text('Add'), findsWidgets);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.text('Add').first);
    await tester.pump();

    expect(find.text('Added'), findsWidgets); // строка и SnackBar
    expect(find.text('1'), findsOneWidget); // бейдж
  });
}