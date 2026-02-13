import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/profile/connexion/email_auth_page.dart';

void main() {
  group('EmailAuthPage Widget Tests', () {
    testWidgets('renders SIGN UP UI correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: EmailAuthPage(isSignUp: true)),
      );

      await tester.pumpAndSettle();

      expect(find.text('SIGN UP'), findsWidgets);
      expect(find.textContaining('new account'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('renders LOG IN UI correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: EmailAuthPage(isSignUp: false)),
      );

      await tester.pumpAndSettle();

      expect(find.text('LOG IN'), findsWidgets);
      expect(find.textContaining('existing account'), findsOneWidget);
      expect(find.textContaining('Forgot'), findsOneWidget);
    });

    // testWidgets('shows error snackbar if fields are empty', (tester) async {
    //   await tester.pumpWidget(
    //     const MaterialApp(home: EmailAuthPage()),
    //   );

    //   await tester.pumpAndSettle();

    //   await tester.tap(find.byType(InkWell).last);
    //   await tester.pump();

    //   expect(find.textContaining('Please fill all fields'), findsOneWidget);
    // });

    // testWidgets('toggles password visibility', (tester) async {
    //   await tester.pumpWidget(
    //     const MaterialApp(home: EmailAuthPage()),
    //   );

    //   await tester.pumpAndSettle();

    //   final visibilityIcon = find.byIcon(Icons.visibility_off);
    //   expect(visibilityIcon, findsOneWidget);

    //   await tester.tap(visibilityIcon);
    //   await tester.pump();

    //   expect(find.byIcon(Icons.visibility), findsOneWidget);
    // });

    // testWidgets('shows loading spinner when submitting', (tester) async {
    //   await tester.pumpWidget(
    //     const MaterialApp(home: EmailAuthPage()),
    //   );

    //   await tester.pumpAndSettle();

    //   await tester.enterText(find.byType(TextField).first, 'test@mail.com');
    //   await tester.enterText(find.byType(TextField).last, '123456');

    //   await tester.tap(find.byType(InkWell).last);
    //   await tester.pump();

    //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // });

    // testWidgets('shows success snackbar after signup', (tester) async {
    //   await tester.pumpWidget(
    //     const MaterialApp(home: EmailAuthPage(isSignUp: true)),
    //   );

    //   await tester.pumpAndSettle();

    //   await tester.enterText(find.byType(TextField).first, 'test@mail.com');
    //   await tester.enterText(find.byType(TextField).last, '123456');

    //   await tester.tap(find.byType(InkWell).last);
    //   await tester.pump();

    //   await tester.pump(const Duration(seconds: 2));
    //   await tester.pumpAndSettle();

    //   expect(find.textContaining('Account created'), findsOneWidget);
    // });

    // testWidgets('shows success snackbar after login', (tester) async {
    //   await tester.pumpWidget(
    //     const MaterialApp(home: EmailAuthPage(isSignUp: false)),
    //   );

    //   await tester.pumpAndSettle();

    //   await tester.enterText(find.byType(TextField).first, 'test@mail.com');
    //   await tester.enterText(find.byType(TextField).last, '123456');

    //   await tester.tap(find.byType(InkWell).last);
    //   await tester.pump();

    //   await tester.pump(const Duration(seconds: 2));
    //   await tester.pumpAndSettle();

    //   expect(find.textContaining('Logged in'), findsOneWidget);
    // });
  });
}