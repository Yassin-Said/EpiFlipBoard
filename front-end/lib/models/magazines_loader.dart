import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:epiflipboard/pages/global.dart' as global;
import 'package:epiflipboard/models/post.dart';
import 'package:epiflipboard/models/magazines_model.dart';

class MagazineService {

  static Future<List<Magazine>> fetchPosts(Future<List<Magazine>> magazineFuture) async {
    final magazines = await magazineFuture;

  for (Magazine mag in magazines) {
    final collectionResponse = await http.get(
      Uri.parse('https://epiflipboard-iau1.onrender.com/getCollection/${mag.id}'),
    );
    if (collectionResponse.statusCode == 200) {
      final decodedCollection = jsonDecode(collectionResponse.body);

      if (decodedCollection['success'] == true) {
        final List dataCollection = decodedCollection['data'];

        mag.posts = [];

        for (var item in dataCollection) {
          final postId = item['post_id']?.toString();
          if (postId == null || postId.isEmpty) continue;

          final postResponse = await http.get(
            Uri.parse('https://epiflipboard-iau1.onrender.com/getPostsById/$postId'),
          );
          if (postResponse.statusCode == 200) {
            final decodedPost = jsonDecode(postResponse.body);

            if (decodedPost['success'] == true && decodedPost['posts'] != null) {
              final List postData = decodedPost['posts'];

              mag.posts.addAll(
                postData.map((json) => DetailedPost.fromBackendJson(Map<String, dynamic>.from(json))),
              );
            }
          }
        }
      }
    } else {
      throw Exception('Erreur lors de la récupération des posts');
    }
  }

    return magazines;
  }


  static Future<List<Magazine>> fetchMagazines() async {
    final response = await http.get(
      Uri.parse('https://epiflipboard-iau1.onrender.com/getProfileCollection/${global.globalUserId}'),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true) {
        final List data = decoded['data'];

        return data
            .map((json) => Magazine.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      }

      return [];
    } else {
      throw Exception('Erreur lors du chargement des magazines');
    }
  }
}