import 'package:flutter/material.dart';
import '../tools/icon_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile/history_page.dart';
import 'profile/find_people_page.dart';
import 'profile/settings_page.dart';
import 'profile/share_profile_page.dart';
import 'global.dart' as global;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const LoggedInProfile(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Créer un magazine");
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

            // Zone vide pour le contenu futur (magazines, etc.)
            Expanded(
              child: Container(
                // futur contenu
              ),
            ),
          ],
        ),
      ),
    );
  }
}