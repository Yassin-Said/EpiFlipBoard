import 'package:flutter/material.dart';
import '../tools/icon_button.dart';

import 'profile/history_page.dart';
import 'profile/find_people_page.dart';
import 'profile/settings_page.dart';
import 'profile/share_profile_page.dart';

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

class LoggedInProfile extends StatelessWidget {
  const LoggedInProfile({super.key});

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
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.purple,
              child: Text(
                "G",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nom
            const Text(
              "GUILLYANN FERRERE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 8),

            // Username + followers
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
              children: [
                ProfileStat(value: "0", title: "Flips"),
                SizedBox(width: 40),
                ProfileStat(value: "0", title: "Likes"),
                SizedBox(width: 40),
                ProfileStat(value: "0", title: "Magazines"),
              ],
            ),

            const SizedBox(height: 40),

            // Zone vide pour le contenu futur (magazines, etc.)
            Expanded(
              child: Container(
                // Ici tu ajouteras plus tard la grille de magazines
              ),
            ),
          ],
        ),
      ),
    );
  }
}