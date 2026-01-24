// Modèle pour un article featured (couverture)
class FeaturedArticle {
  final String title;
  final String source;
  final String? description;
  final String? timeAgo;
  final String? imageUrl;
  final String? url;

  FeaturedArticle({
    required this.title,
    required this.source,
    this.description,
    this.timeAgo,
    this.imageUrl,
    this.url
  });

  factory FeaturedArticle.fromJson(Map<String, dynamic> json) {
    return FeaturedArticle(
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      description: json['description'],
      timeAgo: json['timeAgo'],
      imageUrl: json['imageUrl'],
      url: json['url']
    );
  }
}