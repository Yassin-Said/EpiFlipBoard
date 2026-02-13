import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/profile/connexion/auth_selection_page.dart';

void main() {
  testWidgets('Auth page renders correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AuthSelectionPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining("SIGN UP"), findsOneWidget);
    expect(find.text("Google"), findsOneWidget);
  });
}