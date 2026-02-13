import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/models/person.dart';


void main() {
  test('Person.fromJson handles missing fields', () {
    final Map<String, dynamic> json = {};

    final person = Person.fromJson(json);

    expect(person.name, '');
    expect(person.description, '');
    expect(person.verified, false);
    expect(person.avatarUrl, isNull);
    expect(person.isFollowing, false);
  });

  test('Person.fromJson parses all fields correctly', () {
    final Map<String, dynamic> json = {
      'name': 'Alice',
      'description': 'Developer',
      'verified': true,
      'avatarUrl': 'http://example.com/avatar.png',
      'isFollowing': true,
    };

    final person = Person.fromJson(json);

    expect(person.name, 'Alice');
    expect(person.description, 'Developer');
    expect(person.verified, true);
    expect(person.avatarUrl, 'http://example.com/avatar.png');
    expect(person.isFollowing, true);
  });
}