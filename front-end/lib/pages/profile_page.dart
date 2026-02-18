import 'package:flutter/material.dart';
import '../tools/icon_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile/history_page.dart';
import 'profile/find_people_page.dart';
import 'profile/settings_page.dart';
import 'profile/share_profile_page.dart';
import 'global.dart' as global;
import 'package:epiflipboard/models/post.dart';
import 'package:epiflipboard/models/magazines_model.dart';
import 'package:epiflipboard/pages/create_magazine_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const LoggedInProfile(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateMagazinePage()),
          );

          if (result != null) {
            final postResponse = await http.post(
              Uri.parse('https://epiflipboard-iau1.onrender.com/createProfileCollection'),
              headers: {
                "Content-Type": "application/json",
              },
              body: jsonEncode({
                "author_id": global.globalUserId,
                "title": result["title"],
              }),
            );

            if (postResponse.statusCode == 200) {
              final decodedPost = jsonDecode(postResponse.body);
              if (decodedPost['success'] == true) {
                final magData = decodedPost['data'][0];
                var newMag = Magazine(
                  id: magData['id'],
                  title: result["title"],
                );
                global.magazineClass.addMagazine(newMag);
              }
            }
          }
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String title;
  final String value;

  const ProfileStat({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class LoggedInProfile extends StatefulWidget {
  const LoggedInProfile({super.key});

  @override
  State<LoggedInProfile> createState() => _LoggedInProfileState();
}

class _LoggedInProfileState extends State<LoggedInProfile> {
  String username = global.globalUsername;
  String avatarUrl = global.globalAvatarUrl;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }


  Future<void> fetchProfile() async {
    try {
      final Uri url = Uri.parse(
          "https://epiflipboard-iau1.onrender.com/getProfileByToken/${global.globalTokenOauth}");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'].isNotEmpty) {
          final profile = data['data'][0];
          setState(() {
            username = profile['username'] ?? "No Name";
            avatarUrl = profile['avatar_url'] ?? "";
            // Mettre à jour la globale aussi si tu veux
            global.globalUsername = username;
            global.globalAvatarUrl = avatarUrl;
          });
        } else {
          debugPrint("❌ Profil non trouvé");
        }
      } else {
        debugPrint("❌ Erreur API: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Erreur fetchProfile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icônes en haut à droite
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.white70),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryPage()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white70),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShareProfilePage()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add, color: Colors.white70),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FindPeoplePage()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white70),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Photo de profil
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.purple,
              backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? Text(
                      username.isNotEmpty ? username[0].toUpperCase() : "U",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),

            const SizedBox(height: 20),

            // Username dynamique
            Text(
              username, // plus de const ici !
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 8),

            // Username + followers (statique pour l'instant)
            const Text(
              "@Aitroxy · 0 Followers",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            // Stats en ligne
            const Row(
              // children: [...]
            ),

            const SizedBox(height: 40),

            AnimatedBuilder(
              animation: global.magazineClass,
              builder: (context, _) {
                return Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double itemSize = constraints.maxWidth / 2;

                      return GridView.builder(
                        itemCount: global.magazineClass.magazines.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final mag = global.magazineClass.magazines[index];
                          final bool hasImage = mag.posts.isNotEmpty;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MagazinePostsPage(magazine: mag),
                                ),
                              );
                            },
                            child: Container(
                              width: itemSize,
                              height: itemSize,
                              margin: const EdgeInsets.all(2),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  hasImage
                                      ? Image.network(mag.posts.first.imageUrl, fit: BoxFit.cover)
                                      : Container(color: Colors.red),
                                  Container(color: Colors.black.withOpacity(0.35)),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        mag.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
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
              },
            )
          ],
        ),
      ),
    );
  }
}

class MagazinePostsPage extends StatelessWidget {
  final Magazine magazine;

  const MagazinePostsPage({super.key, required this.magazine});


  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Cannot open link: $url"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(magazine.title),
        backgroundColor: Colors.black,
      ),
      body: _buildArticlesList(),
    );
  }

  Widget _buildArticlesList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: magazine.posts.length,
      separatorBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 1,
        color: Colors.grey[900],
      ),
      itemBuilder: (context, index) {
        final post = magazine.posts[index];
        return _buildArticleItem(context, post);
      },
    );
  }

  Widget _buildArticleItem(BuildContext context, DetailedPost post) {
    return GestureDetector(
      onTap: () => _openUrl(context, post.source),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[900],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, color: Colors.white30, size: 60),
                    );
                  },
                ),
              ),

            Text(
              post.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 12),

            if (post.description.isNotEmpty)
              Text(
                post.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

            const SizedBox(height: 16),

            Text(
              _extractDomain(post.source),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceFirst('www.', '');
    } catch (_) {
      return url;
    }
  }
}
