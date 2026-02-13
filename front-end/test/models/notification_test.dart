import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/models/notification.dart';


void main() {
  test('fromJson handles missing fields', () {
    final Map<String, dynamic> json = {};

    final notification = NotificationItem.fromJson(json);

    expect(notification.type, 'news');
    expect(notification.category, '');
    expect(notification.title, '');
    expect(notification.source, '');
    expect(notification.timeAgo, '');
    expect(notification.imageUrl, isNull);
    expect(notification.isRead, false);
  });
}