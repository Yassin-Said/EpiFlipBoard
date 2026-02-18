import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/create_magazine_page.dart';

void main() {
  group("CreateMagazinePage Widget Tests", () {

    Future<void> pumpPage(WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CreateMagazinePage(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets("Displays title and input field", (tester) async {
      await pumpPage(tester);

      expect(find.text("Create Magazine"), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text("Create"), findsOneWidget);
    });

    testWidgets("Shows snackbar if input is empty", (tester) async {
      await pumpPage(tester);

      await tester.tap(find.text("Create"));
      await tester.pump();

      expect(find.text("Title required"), findsOneWidget);
    });

    testWidgets("Returns entered title when valid", (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateMagazinePage(),
                  ),
                );
              },
              child: const Text("OPEN"),
            ),
          ),
        ),
      );

      await tester.tap(find.text("OPEN"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), "My Magazine");
      await tester.tap(find.text("Create"));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!["title"], equals("My Magazine"));
    });

    testWidgets("Close button closes page", (tester) async {
      await pumpPage(tester);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(CreateMagazinePage), findsNothing);
    });

  });
}