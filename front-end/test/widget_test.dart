import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/feed_page.dart';

void main() {
  testWidgets('Feed page renders correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForYouPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("FOR YOU"), findsOneWidget);
  });
}