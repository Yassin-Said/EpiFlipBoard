class ExploreCategory {
  final String title;
  final String subtitle;
  final String? imageUrl;

  ExploreCategory({
    required this.title,
    required this.subtitle,
    this.imageUrl,
  });

  factory ExploreCategory.fromJson(Map<String, dynamic> json) {
    return ExploreCategory(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }
}