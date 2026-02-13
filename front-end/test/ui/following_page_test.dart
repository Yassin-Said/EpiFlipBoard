import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/following_page.dart';

void main() {
  final fakeArticles = [
    {
      "title": "Test Article",
      "description": "Description test",
      "source": "TestSource",
      "sourceImage": null,
      "timeAgo": "2h ago",
      "imageUrl": null,
      "url": "https://example.com"
    }
  ];

  final fakeTags = [
    {
      "name": "SPORT",
      "followers": "5",
      "coverImage": null,
      "articles": fakeArticles,
    },
    {
      "name": "POLITIQUE",
      "followers": "8",
      "coverImage": null,
      "articles": fakeArticles,
    }
  ];

  testWidgets('FollowingPage renders base UI', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: FollowingPage()),
    );

    await tester.pumpAndSettle();

    expect(find.text('FOLLOWING'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  // testWidgets('Search filters tags correctly', (tester) async {
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: TestFollowingWrapper(tags: fakeTags),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   expect(find.textContaining('TENNIS'), findsOneWidget);
  //   expect(find.textContaining('POLITIQUE'), findsOneWidget);

  //   await tester.enterText(find.byType(TextField), 'TENNIS');
  //   await tester.pumpAndSettle();

  //   expect(find.textContaining('TENNIS'), findsOneWidget);
  //   expect(find.textContaining('POLITIQUE'), findsNothing);
  // });

  // testWidgets('Tap on tag opens TagArticlesPage', (tester) async {
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: TestFollowingWrapper(tags: fakeTags),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   await tester.tap(find.textContaining('SPORT').first);
  //   await tester.pumpAndSettle();

  //   expect(find.text('# SPORT'), findsOneWidget);
  //   expect(find.text('5 Followers'), findsOneWidget);
  // });

  testWidgets('TagArticlesPage renders articles correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TagArticlesPage(
          tagName: "SPORT",
          followers: "5",
          articles: fakeArticles,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Test Article'), findsOneWidget);
    expect(find.text('Description test'), findsOneWidget);
    expect(find.text('TestSource'), findsOneWidget);
  });

  testWidgets('Action buttons exist on article', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TagArticlesPage(
          tagName: "SPORT",
          followers: "5",
          articles: fakeArticles,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byIcon(Icons.comment_outlined), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}

/// -------------------------------
/// Wrapper pour injecter des tags
/// -------------------------------

class TestFollowingWrapper extends StatefulWidget {
  final List<Map<String, dynamic>> tags;

  const TestFollowingWrapper({super.key, required this.tags});

  @override
  State<TestFollowingWrapper> createState() => _TestFollowingWrapperState();
}

class _TestFollowingWrapperState extends State<TestFollowingWrapper> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            final page = FollowingPage();
            final state = page.createState() as dynamic;

            state.followedTags.clear();
            state.followedTags.addAll(widget.tags);

            return page;
          },
        ),
      ),
    );
  }
}