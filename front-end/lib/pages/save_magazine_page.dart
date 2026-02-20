import 'package:epiflipboard/models/post.dart';
import 'package:flutter/material.dart';
import 'global.dart' as global;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:epiflipboard/models/magazines_model.dart';

class SelectMagazinePage extends StatelessWidget {
  final DetailedPost addedPost;

  const SelectMagazinePage({super.key, required this.addedPost});

  void _selectMagazine(BuildContext context, String magazineId) async {
    final postResponse = await http.post(
      Uri.parse('https://epiflipboard-iau1.onrender.com/createCollection'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "post_id": addedPost.id,
        "collection_id": magazineId,
      }),
    );

    if (postResponse.statusCode == 200) {
      final decodedPost = jsonDecode(postResponse.body);
      if (decodedPost['success'] == true) {
        final magData = decodedPost['data'][0];
        global.magazineClass.addPost(magazineId, addedPost);
      }
    }
    Navigator.pop(context, {
      "magazineId": magazineId,
      "postId": addedPost.id,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Save to Magazine",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: AnimatedBuilder(
        animation: global.magazineClass,
        builder: (context, _) {
          final magazines = global.magazineClass.magazines;

          if (magazines.isEmpty) {
            return const Center(
              child: Text(
                "No magazines",
                style: TextStyle(color: Colors.white60),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: magazines.length,
            itemBuilder: (context, index) {
              final mag = magazines[index];
              final hasImage = mag.posts.isNotEmpty;

              return GestureDetector(
                onTap: () => _selectMagazine(context, mag.id),

                child: Container(
                  height: 70,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(
                    children: [
                      // ===== IMAGE =====
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          width: 54,
                          height: 54,
                          child: hasImage
                              ? Image.network(
                                  mag.posts.first.imageUrl,
                                  fit: BoxFit.cover,
                                )
                              : Container(color: Colors.red),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // ===== TITLE =====
                      Expanded(
                        child: Text(
                          mag.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}