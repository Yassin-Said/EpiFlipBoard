import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/profile/connexion/auth_selection_page.dart';

void main() {
  Future<void> pumpAuthPage(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AuthSelectionPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('AuthSelectionPage Widget Tests', () {
    testWidgets('renders signup UI correctly', (tester) async {
      await pumpAuthPage(tester);

      expect(find.textContaining("SIGN UP"), findsOneWidget);
      expect(find.text("Google"), findsOneWidget);
      expect(find.textContaining("Terms of Use"), findsOneWidget);
      expect(find.textContaining("Privacy Policy"), findsOneWidget);
    });

    testWidgets('renders subtitle correctly for signup', (tester) async {
      await pumpAuthPage(tester);

      expect(find.text("Get the most out of Flipboard"), findsOneWidget);
    });

    testWidgets('switches from signup to login mode', (tester) async {
      await pumpAuthPage(tester);

      await tester.tap(find.text("Log in"));
      await tester.pumpAndSettle();

      expect(find.textContaining("WELCOME BACK"), findsOneWidget);
      expect(find.text("Please log in to continue"), findsOneWidget);
    });

    testWidgets('switches back from login to signup mode', (tester) async {
      await pumpAuthPage(tester);

      await tester.tap(find.text("Log in"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Sign up"));
      await tester.pumpAndSettle();

      expect(find.textContaining("SIGN UP"), findsOneWidget);
    });

    testWidgets('google auth button exists and is tappable', (tester) async {
      await pumpAuthPage(tester);

      final googleBtn = find.text("Google");
      expect(googleBtn, findsOneWidget);

      await tester.tap(googleBtn);
      await tester.pump();
    });

    testWidgets('renders terms text correctly', (tester) async {
      await pumpAuthPage(tester);

      expect(find.textContaining("By continuing, you accept"), findsOneWidget);
    });

    testWidgets('contains Google icon', (tester) async {
      await pumpAuthPage(tester);

      expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
    });

    testWidgets('contains main column layout', (tester) async {
      await pumpAuthPage(tester);

      expect(find.byType(Column), findsWidgets);
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}