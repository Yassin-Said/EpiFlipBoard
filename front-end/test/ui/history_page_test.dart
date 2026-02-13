import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/profile/history_page.dart';

void main() {
  testWidgets('HistoryPage renders base UI', (WidgetTester tester) async {
    // Construire l'app avec la page History
    await tester.pumpWidget(
      const MaterialApp(
        home: HistoryPage(),
      ),
    );

    // Vérifie que l'AppBar affiche le titre
    expect(find.text('HISTORY'), findsOneWidget);

    // Vérifie que le bouton Clear est présent
    expect(find.text('Clear'), findsOneWidget);

    // Vérifie qu'au moins un item d'historique est présent
    expect(find.textContaining('The Only Recap'), findsOneWidget);

    // Vérifie que le nom de la source apparaît
    expect(find.text('Looper'), findsOneWidget);

    // Vérifie qu'il y a des icônes interactives (share, comment, like...)
    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byIcon(Icons.comment_outlined), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.more_vert), findsOneWidget);

    // Vérifie que le widget affiche la durée
    expect(find.text('17:01'), findsOneWidget);
  });
}