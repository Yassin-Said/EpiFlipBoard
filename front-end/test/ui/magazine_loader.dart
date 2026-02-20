import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:epiflipboard/models/magazines_loader.dart';
import 'package:epiflipboard/pages/global.dart' as global;

void main() {
  group("MagazineService", () {
    test("fetchMagazines returns list", () async {
      global.globalUserId = "123";

      http.Client client = MockClient((request) async {
        return http.Response(jsonEncode({
          "success": true,
          "data": [
            {"id": "1", "name": "Tech"},
            {"id": "2", "name": "News"}
          ]
        }), 200);
      });

      final mags = await MagazineService.fetchMagazines();

      expect(mags.length, 2);
      expect(mags.first.title, "Tech");
    });
  });
}