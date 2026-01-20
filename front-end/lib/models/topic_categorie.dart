class Topic {
  final String name;
  final List<String> relatedTopics;

  Topic({required this.name, this.relatedTopics = const []});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      name: json['name'] ?? '',
      relatedTopics: List<String>.from(json['relatedTopics'] ?? []),
    );
  }
}