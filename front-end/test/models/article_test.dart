import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/models/article.dart';

void main() {
  group('FeaturedArticle', () {
    test('can be created with all fields', () {
      final article = FeaturedArticle(
        title: 'Test Title',
        source: 'Test Source',
        description: 'A description',
        timeAgo: '2h ago',
        imageUrl: 'https://example.com/image.png',
        url: 'https://example.com',
      );

      expect(article.title, 'Test Title');
      expect(article.source, 'Test Source');
      expect(article.description, 'A description');
      expect(article.timeAgo, '2h ago');
      expect(article.imageUrl, 'https://example.com/image.png');
      expect(article.url, 'https://example.com');
    });

    test('can be created from JSON', () {
      final json = {
        'title': 'JSON Title',
        'source': 'JSON Source',
        'description': 'JSON description',
        'timeAgo': '1h ago',
        'imageUrl': 'https://example.com/json.png',
        'url': 'https://example.com/json',
      };

      final article = FeaturedArticle.fromJson(json);

      expect(article.title, 'JSON Title');
      expect(article.source, 'JSON Source');
      expect(article.description, 'JSON description');
      expect(article.timeAgo, '1h ago');
      expect(article.imageUrl, 'https://example.com/json.png');
      expect(article.url, 'https://example.com/json');
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'title': 'Minimal Title',
        'source': 'Minimal Source',
      };

      final article = FeaturedArticle.fromJson(json);

      expect(article.title, 'Minimal Title');
      expect(article.source, 'Minimal Source');
      expect(article.description, isNull);
      expect(article.timeAgo, isNull);
      expect(article.imageUrl, isNull);
      expect(article.url, isNull);
    });

    test('fromJson handles missing title and source', () {
      final Map<String, dynamic> json = {};

      final article = FeaturedArticle.fromJson(json);

      expect(article.title, '');
      expect(article.source, '');
      expect(article.description, isNull);
      expect(article.timeAgo, isNull);
      expect(article.imageUrl, isNull);
      expect(article.url, isNull);
    });
  });
}