import 'package:epiflipboard/models/search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExploreCategory', () {
    test('fromJson handles missing fields', () {
      final Map<String, dynamic> json = {};

      final category = ExploreCategory.fromJson(json);

      expect(category.title, '');
      expect(category.subtitle, '');
      expect(category.imageUrl, isNull);
    });

    test('fromJson parses all fields correctly', () {
      final Map<String, dynamic> json = {
        'title': 'Sports',
        'subtitle': 'Latest sports news',
        'imageUrl': 'http://example.com/sports.png',
      };

      final category = ExploreCategory.fromJson(json);

      expect(category.title, 'Sports');
      expect(category.subtitle, 'Latest sports news');
      expect(category.imageUrl, 'http://example.com/sports.png');
    });
  });
}