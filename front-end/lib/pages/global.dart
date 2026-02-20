library globals;
import 'package:epiflipboard/models/post.dart';
import 'package:epiflipboard/models/magazines_model.dart';
import 'package:flutter/material.dart';

// Stocke le token OAuth
String globalTokenOauth = "";
String globalEmail = "";

// Tu peux ajouter d'autres infos si nécessaire
String globalUsername = "";
String globalAvatarUrl = "";

String globalUserId = "";

final magazineClass = GlobalMagazine();

class GlobalMagazine extends ChangeNotifier {
  List<Magazine> magazines = [];

  void setMagazines(List<Magazine> newMags) {
    magazines = newMags;
    notifyListeners();
  }
  void addMagazine(Magazine newMags) {
    magazines.add(newMags);
    notifyListeners();
  }
  void addPost(String id, DetailedPost newPost) {
    for (var item in magazines) {
      if (item.id == id) {
        item.posts.add(newPost);
        notifyListeners();
        return;
      }
    }
  }
  void deletePost(String id, String postId) {
    for (var item in magazines) {
      if (item.id == id) {
        for (var post in item.posts) {
          if (post.id == postId) {
            item.posts.remove(post);
            notifyListeners();
            return;
          }
        }
      }
    }
  }
  void deleteMagazine(String magsId) {
    for (var item in magazines) {
      if (item.id == magsId) {
        magazines.remove(item);
        notifyListeners();
        return;
      }
    }
  }
}