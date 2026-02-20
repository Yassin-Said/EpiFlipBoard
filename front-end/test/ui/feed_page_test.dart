import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/feed_page.dart';
import 'package:epiflipboard/models/post.dart';

void main() {
  group("ForYouPage UI Tests", () {
    late Map<String, List<DetailedPost>> fakePosts;

    setUp(() {
      fakePosts = {
        "FOR YOU": [
          DetailedPost(
            id: "1",
            title: "Flutter is awesome",
            source: "https://flutter.dev",
            category: "DEV",
            imageUrl: "",
            timeAgo: "",
            description: "Learn Flutter",
            likes: 10,
            comments: 2,
            flips: 1,
            authorName: "Google",
          ),
          DetailedPost(
            id: "2",
            title: "Dart language",
            source: "https://dart.dev",
            category: "DEV",
            imageUrl: "",
            timeAgo: "",
            description: "Learn Dart",
            likes: 5,
            comments: 1,
            flips: 3,
            authorName: "Dart Team",
          ),
        ]
      };
    });

    Future<void> pumpPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ForYouPage(
            postsByCategory: fakePosts,
            featuredByCategory: const {},
            topics: const [],
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets("Shows category header", (tester) async {
      await pumpPage(tester);

      expect(find.text("FOR YOU"), findsOneWidget);
    });

    testWidgets("Displays posts", (tester) async {
      await pumpPage(tester);

      expect(find.text("Flutter is awesome"), findsOneWidget);
      expect(find.text("Dart language"), findsNothing);
    });

    testWidgets("Scrolls vertically", (tester) async {
      await pumpPage(tester);

      final pageView = find.byType(PageView);
      expect(pageView, findsOneWidget);

      await tester.drag(pageView, const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text("Dart language"), findsOneWidget);
    });

    testWidgets("Like button increments counter", (tester) async {
      await pumpPage(tester);

      expect(find.text("10"), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pump();

      expect(find.text("11"), findsOneWidget);
    });

    testWidgets("Flip button opens save magazine page", (tester) async {
      await pumpPage(tester);

      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      expect(find.text("Save to Magazine"), findsOneWidget);
    });
  });
}