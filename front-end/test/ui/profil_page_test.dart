import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/profile_page.dart';
import 'package:epiflipboard/models/magazines_model.dart';
import 'package:epiflipboard/models/post.dart';
import 'package:epiflipboard/pages/global.dart' as global;

import 'dart:io';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _TestHttpClient();
  }
}

class _TestHttpClient implements HttpClient {
  @override
  noSuchMethod(Invocation invocation) => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  group('Profile Page UI Tests', () {
    setUp(() {
      global.magazineClass.magazines.clear();

      global.globalUsername = "TestUser";
      global.globalAvatarUrl = "";
    });

    testWidgets('ProfilePage renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      expect(find.text('TestUser'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    // testWidgets('Displays magazines grid when magazines exist', (tester) async {
    //   final mag = Magazine(id: '1', title: 'Tech');

    //   mag.posts.add(
    //     DetailedPost(
    //       id: 'p1',
    //       title: 'Flutter',
    //       description: 'Flutter article',
    //       timeAgo: "",
    //       category: '',
    //       imageUrl: 'https://picsum.photos/200',
    //       source: 'https://flutter.dev',
    //     ),
    //   );

    //   global.magazineClass.addMagazine(mag);

    //   await tester.pumpWidget(
    //     const MaterialApp(
    //       home: ProfilePage(),
    //     ),
    //   );

    //   await tester.pumpAndSettle();

    //   expect(find.text('Tech'), findsOneWidget);
    //   expect(find.byType(GridView), findsOneWidget);
    // });

    // testWidgets('Tap on magazine opens MagazinePostsPage', (tester) async {
    //   final mag = Magazine(id: '1', title: 'Science');

    //   mag.posts.add(
    //     DetailedPost(
    //       id: 'p1',
    //       title: 'AI News',
    //       timeAgo: "",
    //       category: "",
    //       description: '',
    //       imageUrl: 'https://picsum.photos/200',
    //       source: 'https://openai.com',
    //     ),
    //   );

    //   global.magazineClass.addMagazine(mag);

    //   await tester.pumpWidget(
    //     const MaterialApp(
    //       home: ProfilePage(),
    //     ),
    //   );

    //   await tester.pumpAndSettle();

    //   final magFinder = find.text('Science');

    //   await tester.ensureVisible(magFinder);
    //   await tester.tap(magFinder);
    //   await tester.pumpAndSettle();

    //   expect(find.text('AI News'), findsOneWidget);
    // });

    testWidgets('MagazinePostsPage shows articles list', (tester) async {
      final mag = Magazine(id: '1', title: 'News');

      mag.posts.add(
        DetailedPost(
          id: 'p1',
          title: 'Breaking',
          timeAgo: "",
          category: '',
          description: 'Breaking news',
          imageUrl: 'https://picsum.photos/200',
          source: 'https://example.com',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MagazinePostsPage(magazine: mag),
        ),
      );

      expect(find.text('Breaking'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}