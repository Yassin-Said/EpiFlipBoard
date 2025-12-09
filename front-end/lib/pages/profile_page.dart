import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tools/icon_button.dart';

import 'profile/history_page.dart';
import 'profile/find_people_page.dart';
import 'profile/settings_page.dart';
import 'profile/share_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoggedIn
          ? LoggedInProfile()
          : LoggedOutProfile(
              onLoginPressed: () {
                setState(() => isLoggedIn = true);
              },
            ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: () {
                print("Créer un magazine");
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            )
          : null,
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

class LoggedOutProfile extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const LoggedOutProfile({required this.onLoginPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Icônes en haut à droite
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
          ),

          const SizedBox(height: 20),

          // Photo + titre alignés à gauche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  child: const Icon(
                    Icons.person,
                    size: 55,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Titre "YOUR PROFILE"
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "YOUR PROFILE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Stats
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                ProfileStat(value: "0", title: "Flips"),
                SizedBox(width: 40),
                ProfileStat(value: "0", title: "Likes"),
                SizedBox(width: 40),
                ProfileStat(value: "0", title: "Magazines"),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Bloc rouge qui prend le reste
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFF3D3D),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Save Stories Into Your Own\nMagazines",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Sign up to save stories for later and access them from any device.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFF3D3D),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}