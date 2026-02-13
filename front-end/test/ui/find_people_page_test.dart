import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/profile/find_people_page.dart';
import 'package:epiflipboard/models/person.dart';

void main() {
  testWidgets('FindPeoplePage renders base UI and toggles follow', (WidgetTester tester) async {
    // Préparer une liste de test
    final testPeople = [
      Person(name: 'Alice', description: 'Developer', verified: true),
      Person(name: 'Bob', description: 'Designer', verified: false),
    ];

    // Construire le widget
    await tester.pumpWidget(
      MaterialApp(
        home: FindPeoplePage(people: testPeople),
      ),
    );

    // Vérifier AppBar
    expect(find.text('Find People to Follow'), findsOneWidget);

    // Vérifier que les personnes apparaissent
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);

    // Vérifier la présence des boutons Follow
    expect(find.text('Follow'), findsNWidgets(2));

    // Vérifier badge verified pour Alice
    expect(find.byIcon(Icons.verified), findsOneWidget);

    // Cliquer sur le bouton Follow de Alice
    await tester.tap(find.widgetWithText(ElevatedButton, 'Follow').first);
    await tester.pump(); // Rebuild après setState

    // Vérifier que le bouton est passé à Following
    expect(find.text('Following'), findsOneWidget);

    // Vérifier le loader pendant l'appel API simulé
    // final state = tester.state<_FindPeoplePageState>(find.byType(FindPeoplePage));
    // state.loadFromApi();
    // await tester.pump(); // commence le Future
    // expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // await tester.pump(const Duration(seconds: 2)); // attendre la fin du Future
    // expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}