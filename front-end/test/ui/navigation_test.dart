import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/main.dart';

void main() {
  testWidgets('App launches correctly', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}