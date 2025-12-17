class NotificationItem {
  final String type; // "activity", "replies", "news"
  final String category;
  final String title;
  final String source;
  final String timeAgo;
  final String? imageUrl;
  final bool isRead;

  NotificationItem({
    required this.type,
    required this.category,
    required this.title,
    required this.source,
    required this.timeAgo,
    this.imageUrl,
    this.isRead = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      type: json['type'] ?? 'news',
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
      imageUrl: json['imageUrl'],
      isRead: json['isRead'] ?? false,
    );
  }
}