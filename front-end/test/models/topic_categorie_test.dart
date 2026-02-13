import 'package:epiflipboard/models/topic_categorie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson handles missing name and relatedTopics', () {
    // ✅ Cast explicite vers Map<String, dynamic>
    final Map<String, dynamic> json = <String, dynamic>{};

    final topic = Topic.fromJson(json);

    expect(topic.name, '');
    expect(topic.relatedTopics, []);
  });
}