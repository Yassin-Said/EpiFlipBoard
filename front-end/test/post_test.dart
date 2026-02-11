import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  test('GET /posts returns valid response', () async {
      final uri = Uri.parse("https://epiflipboard-iau1.onrender.com/posts");

    final response = await http.get(uri);

    expect(response.statusCode, 200);

    final data = jsonDecode(response.body);

    expect(data, isNotNull);
    expect(data["posts"], isA<List>());
  });
}