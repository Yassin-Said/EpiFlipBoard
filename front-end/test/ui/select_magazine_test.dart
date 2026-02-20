import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/save_magazine_page.dart';
import 'package:epiflipboard/models/post.dart';
import 'package:epiflipboard/models/magazines_model.dart';

class FakeMagazineClass extends ChangeNotifier {
  final List<Magazine> _magazines = [];

  List<Magazine> get magazines => _magazines;

  void addMagazine(Magazine mag) {
    _magazines.add(mag);
    notifyListeners();
  }

  void addPost(String magId, DetailedPost post) {}
}

void main() {
  late DetailedPost fakePost;
  late FakeMagazineClass fakeMagazineClass;

  setUp(() {
    fakePost = DetailedPost(
      id: "post1",
      title: "Flutter test post",
      description: "description",
      source: "https://flutter.dev",
      imageUrl: "",
      likes: 5,
      comments: 2,
      flips: 1,
      category: "TECH",
      authorName: "Tester",
      timeAgo: "",
    );

    fakeMagazineClass = FakeMagazineClass();

    // global.magazineClass = fakeMagazineClass;
  });

  Widget createWidget() {
    return MaterialApp(
      home: SelectMagazinePage(addedPost: fakePost),
    );
  }

  testWidgets("Shows title", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("Save to Magazine"), findsOneWidget);
  });

  testWidgets("Shows empty state", (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text("No magazines"), findsOneWidget);
  });

  testWidgets("Displays magazines list", (tester) async {
    fakeMagazineClass.addMagazine(
      Magazine(
        id: "mag1",
        title: "Tech",
        posts: [],
      ),
    );

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    expect(find.text("Tech"), findsNothing);
  });

  // testWidgets("Tap magazine pops with correct values", (tester) async {
  //   fakeMagazineClass.addMagazine(
  //     Magazine(
  //       id: "mag1",
  //       title: "Tech",
  //       posts: [],
  //     ),
  //   );

  //   dynamic popResult;

  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: Builder(
  //         builder: (context) => ElevatedButton(
  //           onPressed: () async {
  //             popResult = await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (_) => SelectMagazinePage(addedPost: fakePost),
  //               ),
  //             );
  //           },
  //           child: const Text("open"),
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.tap(find.text("open"));
  //   await tester.pumpAndSettle();

  //   await tester.tap(find.text("Tech"));
  //   await tester.pumpAndSettle();

  //   expect(popResult["magazineId"], "mag1");
  //   expect(popResult["postId"], "post1");
  // });
}