import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:epiflipboard/pages/explore_page.dart';

// ============================================
// HELPER
// ============================================
Widget buildExplorePage() {
  return const MaterialApp(
    home: ExplorePage(),
  );
}

void main() {

  // ============================================
  // GROUPE 1 : AFFICHAGE INITIAL
  // ============================================
  group('ExplorePage - Affichage initial', () {

    testWidgets('Affiche le loader au démarrage', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      // Juste après le pump, avant que le fetch ne finisse
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Affiche la barre de recherche', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('La barre de recherche a le bon hint text', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      expect(find.text('Search articles...'), findsOneWidget);
    });

    testWidgets('Le bouton close est absent au démarrage', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('Le fond est noir', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.black);
    });
  });

  // ============================================
  // GROUPE 2 : BARRE DE RECHERCHE (UI pure)
  // ============================================
  group('ExplorePage - Barre de recherche (UI)', () {

    // testWidgets('Bouton close apparaît quand on tape du texte', (tester) async {
    //   await tester.pumpWidget(buildExplorePage());

    //   await tester.enterText(find.byType(TextField), 'Flutter');
    //   await tester.pump();

    //   expect(find.byIcon(Icons.close), findsOneWidget);
    // });

    // testWidgets('Bouton close disparaît après avoir vidé le champ', (tester) async {
    //   await tester.pumpWidget(buildExplorePage());

    //   await tester.enterText(find.byType(TextField), 'Flutter');
    //   await tester.pump();

    //   expect(find.byIcon(Icons.close), findsNothing);

    //   await tester.tap(find.byIcon(Icons.close));
    //   await tester.pump();

    //   expect(find.byIcon(Icons.close), findsNothing);
    // });

    testWidgets('Le TextField est vide au démarrage', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text ?? '', isEmpty);
    });

    testWidgets('Le TextField accepte la saisie', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('Le TextField a autofocus activé', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isTrue);
    });

    testWidgets('La barre de recherche a une couleur de fond grise', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasGrayContainer = containers.any((c) =>
        c.decoration is BoxDecoration &&
        (c.decoration as BoxDecoration).color == Colors.grey[900]
      );

      expect(hasGrayContainer, isTrue);
    });
  });

  // ============================================
  // GROUPE 3 : STRUCTURE DES WIDGETS
  // ============================================
  group('ExplorePage - Structure des widgets', () {

    testWidgets('Contient un SafeArea', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Contient un Column comme layout principal', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Contient un Expanded', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      expect(find.byType(Expanded), findsNWidgets(2));
    });

    testWidgets('Contient un Scaffold', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Le CircularProgressIndicator est rouge', (tester) async {
      await tester.pumpWidget(buildExplorePage());

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.color, Colors.red);
    });
  });
}