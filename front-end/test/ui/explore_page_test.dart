// test/ui/explore_page_test.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/explore_page.dart';
import 'package:epiflipboard/models/search.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExplorePage Widget Tests', () {
    final customCategories = [
      ExploreCategory(
        title: "TapMe",
        subtitle: "Subtitle1",
        imageUrl: "https://example.com/image1.jpg",
      ),
      ExploreCategory(
        title: "ClickMe",
        subtitle: "Subtitle2",
        imageUrl: "https://example.com/image2.jpg",
      ),
    ];

    // Test de rendu basique sans réseau
    testWidgets('renders ExplorePage correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(home: ExplorePage(categories: customCategories)),
        );

        // Vérifie que le header est présent
        expect(find.text("EXPLORE"), findsOneWidget);

        // Vérifie qu'au moins une catégorie est affichée
        expect(find.text("TapMe"), findsOneWidget);
      });
    });

    // Test des tabs
    testWidgets('switches tab when tapped', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(home: ExplorePage(categories: customCategories)),
        );

        // Vérifie que l'onglet FEATURED est sélectionné au début
        expect(find.text("FEATURED"), findsOneWidget);

        // Tap sur un autre onglet
        final newsTab = find.text("NEWS");
        await tester.tap(newsTab);
        await tester.pumpAndSettle();

        // Vérifie que la tab a changé
        final selectedStyle = tester.widget<Text>(find.text("NEWS")).style;
        expect(selectedStyle?.color, Colors.red);
      });
    });

    // Test de l'image featured et du titre
    testWidgets('displays featured image and title', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ExplorePage(
              featuredTitle: "Custom Featured",
              featuredImageUrl: "https://example.com/featured.jpg",
            ),
          ),
        );

        expect(find.text("Custom Featured"), findsOneWidget);
      });
    });

    // Test du fallback du titre featured
    testWidgets('featured title fallback works', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(home: ExplorePage()),
        );

        // Le titre par défaut doit apparaître
        expect(find.text("NBA Gambling Scandal"), findsOneWidget);
      });
    });

    // Test de la grille de catégories
    testWidgets('renders custom categories', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(home: ExplorePage(categories: customCategories)),
        );

        for (final cat in customCategories) {
          expect(find.text(cat.title), findsOneWidget);
          expect(find.text(cat.subtitle), findsOneWidget);
        }
      });
    });

    // Test du tap sur une catégorie
    testWidgets('tapping category prints title', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(home: ExplorePage(categories: customCategories)),
        );

        final tapMeFinder = find.text("TapMe");
        await tester.tap(tapMeFinder);
        await tester.pump();
      });
    });

    // Test du search bar
    testWidgets('renders search bar', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(home: ExplorePage(categories: customCategories)),
        );

        expect(find.text("Search Flipboard"), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });
    });

    // Test de la grille avec le loader
    // testWidgets('shows loader when loading categories', (tester) async {
    //   await mockNetworkImagesFor(() async {
    //     await tester.pumpWidget(
    //       MaterialApp(home: ExplorePage(categories: customCategories)),
    //     );

    //     final state = tester.state(find.byType(ExplorePage)) as _ExplorePageState;
    //     state.setState(() => state._isLoading = true);

    //     await tester.pump();
    //     expect(find.byType(CircularProgressIndicator), findsOneWidget);
    //   });
    // });

    // Test que tous les onglets sont présents
    testWidgets('renders all tabs', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(home: ExplorePage(categories: customCategories)),
        );

        final tabs = ["FEATURED", "NEWS", "WATCH", "TECH & SCIENCE"];
        for (final t in tabs) {
          expect(find.text(t), findsOneWidget);
        }
      });
    });

    // Test de gradient overlay sur la catégorie
    testWidgets('category card has gradient overlay', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(home: ExplorePage(categories: customCategories)),
        );

        final container = find.descendant(
            of: find.text("TapMe"), matching: find.byType(Container));
        expect(container, findsWidgets);
      });
    });
  });
}