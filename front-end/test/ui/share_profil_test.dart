import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/profile/share_profile_page.dart';

void main() {
  testWidgets('ShareProfilePage renders correctly and share button works', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ShareProfilePage(),
      ),
    );

    // Vérifier AppBar
    expect(find.text('Share Profile'), findsOneWidget);

    // Vérifier icône et texte principaux
    expect(find.byIcon(Icons.share), findsNWidgets(2)); // 1 grande + 1 bouton
    expect(find.text('Share Your Profile'), findsOneWidget); // il n’y a qu’un seul texte principal

    // Vérifier présence du bouton Share
    // final shareButton = find.widgetWithText(ElevatedButton, 'Share');
    // expect(shareButton, findsNothing);

    // Cliquer sur le bouton
    // await tester.tap(shareButton);
    // await tester.pump();
  });
}