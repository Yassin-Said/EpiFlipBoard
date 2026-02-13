import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/profile/settings_page.dart';
import 'package:epiflipboard/models/setting_item.dart';

void main() {
  Future<void> pumpSettings(WidgetTester tester,
      {List<SettingItem>? custom}) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/auth_page': (_) => const Scaffold(body: Text("AUTH PAGE")),
        },
        home: SettingsPage(customSettings: custom),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SettingsPage Widget Tests', () {
    testWidgets('renders settings page title', (tester) async {
      await pumpSettings(tester);

      expect(find.text("SETTINGS"), findsOneWidget);
    });

  //  testWidgets('renders section headers', (tester) async {
  //   await pumpSettings(tester);

  //   // Scroll pour afficher les sections basses
  //   await tester.drag(find.byType(ListView), const Offset(0, -1500));
  //   await tester.pumpAndSettle();

  //   expect(find.text("Account Options"), findsOneWidget);
  //   expect(find.text("Notifications"), findsOneWidget);
  //   expect(find.text("Display Options"), findsOneWidget);
  //   expect(find.text("Advanced"), findsOneWidget);
  //   expect(find.text("About"), findsOneWidget);
  // });

    testWidgets('renders logout option', (tester) async {
      await pumpSettings(tester);

      expect(find.text("Log Out"), findsOneWidget);
    });

    testWidgets('tap logout navigates to auth page', (tester) async {
      await pumpSettings(tester);

      await tester.tap(find.text("Log Out"));
      await tester.pumpAndSettle();

      expect(find.text("AUTH PAGE"), findsOneWidget);
    });

    testWidgets('renders switch and toggles it', (tester) async {
      await pumpSettings(tester);

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      final Switch sw = tester.widget(switchFinder);
      expect(sw.value, true);
    });

  //   testWidgets('renders checkbox and toggles it', (tester) async {
  //   await pumpSettings(tester);

  //   // Scroll jusqu'à la checkbox
  //   await tester.drag(find.byType(ListView), const Offset(0, -1200));
  //   await tester.pumpAndSettle();

  //   final checkboxFinder = find.byType(Checkbox);
  //   expect(checkboxFinder, findsOneWidget);

  //   await tester.tap(checkboxFinder);
  //   await tester.pumpAndSettle();

  //   final Checkbox cb = tester.widget(checkboxFinder);
  //   expect(cb.value, true);
  // });

    testWidgets('erase dialog opens and closes', (tester) async {
      await pumpSettings(tester);

      await tester.tap(find.text("Erase all content and settings"));
      await tester.pumpAndSettle();

      expect(find.text("Erase All Data?"), findsOneWidget);

      await tester.tap(find.text("Cancel"));
      await tester.pumpAndSettle();

      expect(find.text("Erase All Data?"), findsNothing);
    });

    testWidgets('erase dialog confirm works', (tester) async {
      await pumpSettings(tester);

      await tester.tap(find.text("Erase all content and settings"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Erase"));
      await tester.pumpAndSettle();

      expect(find.text("Erase All Data?"), findsNothing);
    });

    testWidgets('back arrow pops navigation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    });

    testWidgets('custom settings override default', (tester) async {
      final custom = [
        SettingItem.simple(
          title: "Test Option",
          onTap: () {},
        ),
      ];

      await pumpSettings(tester, custom: custom);

      expect(find.text("Test Option"), findsOneWidget);
      expect(find.text("Log Out"), findsNothing);
    });

    // testWidgets('addSetting dynamically adds new item', (tester) async {
    //   final key = GlobalKey<_SettingsPageState>();

    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: SettingsPage(key: key),
    //     ),
    //   );

    //   await tester.pumpAndSettle();

    //   key.currentState!.addSetting(
    //     SettingItem.simple(title: "Injected", onTap: () {}),
    //   );

    //   await tester.pumpAndSettle();

    //   expect(find.text("Injected"), findsOneWidget);
    // });
  });
}