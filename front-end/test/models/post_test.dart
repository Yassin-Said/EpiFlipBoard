import 'package:epiflipboard/models/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DetailedPost', () {
    test('fromJson handles missing fields', () {
      final Map<String, dynamic> json = {};

      final post = DetailedPost.fromJson(json);

      expect(post.id, '');
      expect(post.title, '');
      expect(post.source, '');
      expect(post.category, '');
      expect(post.timeAgo, '');
      expect(post.imageUrl, isNull);
      expect(post.authorUrl, isNull);
      expect(post.description, '');
      expect(post.likes, 0);
      expect(post.comments, 0);
      expect(post.flips, 0);
      expect(post.authorName, isNull);
    });

    test('fromJson parses all fields correctly', () {
      final Map<String, dynamic> json = {
        'id': '123',
        'title': 'Test Post',
        'source': 'Example News',
        'category': 'Tech',
        'timeAgo': '2h',
        'imageUrl': 'http://example.com/img.png',
        'authorUrl': 'http://example.com/author.png',
        'description': 'This is a detailed post',
        'likes': 10,
        'comments': 5,
        'flips': 2,
        'authorName': 'Alice',
      };

      final post = DetailedPost.fromJson(json);

      expect(post.id, '123');
      expect(post.title, 'Test Post');
      expect(post.source, 'Example News');
      expect(post.category, 'Tech');
      expect(post.timeAgo, '2h');
      expect(post.imageUrl, 'http://example.com/img.png');
      expect(post.authorUrl, 'http://example.com/author.png');
      expect(post.description, 'This is a detailed post');
      expect(post.likes, 10);
      expect(post.comments, 5);
      expect(post.flips, 2);
      expect(post.authorName, 'Alice');
    });

    test('fromBackendJson maps backend fields correctly', () {
      final Map<String, dynamic> json = {
        'id': '456',
        'title': 'Backend Post',
        'link': 'Backend News',
        'tags': 'World',
        'created_at': '1d',
        'image_url': 'http://example.com/back.png',
        'summary': 'Summary from backend',
        'profiles': {
          'avatar_url': 'http://example.com/author_back.png',
          'username': 'Bob',
        },
      };

      final post = DetailedPost.fromBackendJson(json);

      expect(post.id, '456');
      expect(post.title, 'Backend Post');
      expect(post.source, 'Backend News');
      expect(post.category, 'World');
      expect(post.timeAgo, '1d');
      expect(post.imageUrl, 'http://example.com/back.png');
      expect(post.description, 'Summary from backend');
      expect(post.likes, 0);
      expect(post.comments, 0);
      expect(post.flips, 0);
      expect(post.authorUrl, 'http://example.com/author_back.png');
      expect(post.authorName, 'Bob');
    });
  });
}