import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/global.dart';
import 'package:epiflipboard/models/magazines_model.dart';
import 'package:epiflipboard/models/post.dart';

void main() {
  group("GlobalMagazine tests", () {
    late GlobalMagazine globalMagazine;

    setUp(() {
      globalMagazine = GlobalMagazine();
    });

    test("Add magazine", () {
      final mag = Magazine(id: "1", title: "Tech");

      globalMagazine.addMagazine(mag);

      expect(globalMagazine.magazines.length, 1);
      expect(globalMagazine.magazines.first.title, "Tech");
    });

    test("Set magazines", () {
      final mags = [
        Magazine(id: "1", title: "Tech"),
        Magazine(id: "2", title: "News"),
      ];

      globalMagazine.setMagazines(mags);

      expect(globalMagazine.magazines.length, 2);
    });

    test("Add post to magazine", () {
      final mag = Magazine(id: "1", title: "Tech");

      globalMagazine.addMagazine(mag);

      final post = DetailedPost(
        id: "p1",
        title: "Flutter",
        description: "desc",
        timeAgo: "",
        source: "test",
        imageUrl: "",
        likes: 0,
        comments: 0,
        flips: 0,
        category: "DEV",
        authorName: "Me",
      );

      globalMagazine.addPost("1", post);

      expect(globalMagazine.magazines.first.posts.length, 1);
      expect(globalMagazine.magazines.first.posts.first.id, "p1");
    });
  });
}