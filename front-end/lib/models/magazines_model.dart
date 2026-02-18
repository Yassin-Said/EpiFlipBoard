import 'package:epiflipboard/models/post.dart';

class Magazine {
  final String id;
  final String title;
  List<DetailedPost> posts;

  Magazine({
    required this.title,
    required this.id,
    List<DetailedPost>? posts,
  }) : posts = posts ?? <DetailedPost>[];

  factory Magazine.fromJson(Map<String, dynamic> json) {
    return Magazine(
      title: json['name'] ?? '',
      id: json['id'] ?? '',
      posts: <DetailedPost>[],
    );
  }
  
  @override
  String toString() {
    return 'Magazine(id: $id, title: $title, postsCount: ${posts.length})';
  }
}