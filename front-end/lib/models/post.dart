// Modèle pour un post complet
class DetailedPost {
  final String title;
  final String source;
  final String category;
  final String timeAgo;
  final String? imageUrl;
  final String description;
  final int likes;
  final int comments;
  final int flips;
  final String? authorName;

  DetailedPost({
    required this.title,
    required this.source,
    required this.category,
    required this.timeAgo,
    this.imageUrl,
    required this.description,
    this.likes = 0,
    this.comments = 0,
    this.flips = 0,
    this.authorName,
  });

  factory DetailedPost.fromJson(Map<String, dynamic> json) {
    return DetailedPost(
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      category: json['category'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
      imageUrl: json['imageUrl'],
      description: json['description'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      flips: json['flips'] ?? 0,
      authorName: json['authorName'],
    );
  }
}