import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('POST /countPostLikes returns valid counts', () async {
    final response = await http.post(
      Uri.parse("https://epiflipboard-iau1.onrender.com/countPostLikes"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "post_ids": ["00038c4a-7c07-4b7f-b8f7-1a60771c43a9"],
      }),
    );

    expect(response.statusCode, 200);

    final data = jsonDecode(response.body);

    expect(data["data"], isA<Map>());
  });
}