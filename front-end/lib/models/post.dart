// Modèle pour un post complet



class DetailedPost {
  final String id;
  final String title;
  final String source;
  final String category;
  final String timeAgo;
  final String? imageUrl;
  final String? authorUrl;
  final String description;
  int likes;
  final int comments;
  final int flips;
  final String? authorName;

  DetailedPost({
    required this.title,
    required this.source,
    required this.category,
    required this.timeAgo,
    required this.id,
    this.imageUrl,
    this.authorUrl,
    required this.description,
    this.likes = 0,
    this.comments = 0,
    this.flips = 0,
    this.authorName,
  });


  factory DetailedPost.fromJson(Map<String, dynamic> json) {
    return DetailedPost(
      title: json['title'] ?? '',
      id: json['id'] ?? '',
      source: json['source'] ?? '',
      category: json['category'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
      imageUrl: json['imageUrl'],
      description: json['description'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      flips: json['flips'] ?? 0,
      authorUrl: json['authorUrl'],
      authorName: json['authorName'],
    );
  }

  factory DetailedPost.fromBackendJson(Map<String, dynamic> json) {
    return DetailedPost(
      title: json['title'] ?? '',
      id: json['id'] ?? '',
      source: json['link'] ?? '',
      category: json['tags'] ?? '',
      timeAgo: json['created_at'] ?? '',
      imageUrl: json['image_url'] ?? '',
      description: json['summary'] ?? '',
      likes: 0,
      comments: 0,
      flips: 0,
      authorUrl: json["profiles"]?["avatar_url"],
      authorName: json["profiles"]?['username'],
    );
  }
}