import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/profile_page.dart';

void main() {
  testWidgets('Profile page loads correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfilePage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining("@Aitroxy · 0 Followers"), findsWidgets);
  });
}