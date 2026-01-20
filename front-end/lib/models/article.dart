// Modèle pour un article featured (couverture)
class FeaturedArticle {
  final String title;
  final String source;
  final String? imageUrl;

  FeaturedArticle({
    required this.title,
    required this.source,
    this.imageUrl,
  });

  factory FeaturedArticle.fromJson(Map<String, dynamic> json) {
    return FeaturedArticle(
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }
}