import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/models/magazines_model.dart';

void main() {
  group("Magazine model", () {
    test("Constructor works", () {
      final mag = Magazine(id: "1", title: "Tech");

      expect(mag.id, "1");
      expect(mag.title, "Tech");
      expect(mag.posts.length, 0);
    });

    test("Factory fromJson works", () {
      final json = {
        "id": "10",
        "name": "Science",
      };

      final mag = Magazine.fromJson(json);

      expect(mag.id, "10");
      expect(mag.title, "Science");
      expect(mag.posts, isEmpty);
    });

    test("toString returns formatted string", () {
      final mag = Magazine(id: "1", title: "Tech");

      final result = mag.toString();

      expect(result.contains("Tech"), true);
      expect(result.contains("postsCount"), true);
    });
  });
}