class Person {
  final String name;
  final String description;
  final bool verified;
  final String? avatarUrl;
  bool isFollowing;

  Person({
    required this.name,
    required this.description,
    this.verified = false,
    this.avatarUrl,
    this.isFollowing = false,
  });

  // Factory pour créer depuis JSON (API)
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      verified: json['verified'] ?? false,
      avatarUrl: json['avatarUrl'],
      isFollowing: json['isFollowing'] ?? false,
    );
  }
}