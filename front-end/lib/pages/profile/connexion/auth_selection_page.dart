import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:epiflipboard/pages/profile/connexion/email_auth_page.dart';
import 'package:epiflipboard/models/magazines_loader.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../global.dart' as globals;

class AuthSelectionPage extends StatefulWidget {
  const AuthSelectionPage({super.key});

  @override
  State<AuthSelectionPage> createState() => _AuthSelectionPageState();
}

class _AuthSelectionPageState extends State<AuthSelectionPage> {
  bool isSignUp = true;

  Future<bool> checkProfile(String email) async {
    try {
      final Uri url = Uri.parse(
        "https://epiflipboard-iau1.onrender.com/getProfileByEmail/${email}"
      );

      final response = await http.get(url,);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data.isNotEmpty) {
          globals.globalUserId = data[0]['id']; 
        }
        globals.magazineClass.setMagazines(
            await MagazineService.fetchPosts(
              MagazineService.fetchMagazines(),
            ));
        return data != null && data.isNotEmpty;
      } else {
        debugPrint("❌ Erreur API: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ ACCOUNT CHECK ERROR: $e");
      return false;
    }
  }

  Future<void> _googleOAuth(BuildContext context) async {
    try {
      final GoogleSignInAccount? user = await GoogleSignIn().signIn();

      if (user == null) {
        debugPrint("❌ Login annulé");
        return;
      }

      final GoogleSignInAuthentication auth = await user.authentication;

      debugPrint("✅ GOOGLE LOGIN SUCCESS");

      globals.globalTokenOauth = auth.accessToken ?? "";
      globals.globalUsername = user.displayName ?? "NoName";
      globals.globalAvatarUrl = user.photoUrl ?? "";
      globals.globalEmail = user.email ?? "";

      debugPrint("Access Token: ${auth.accessToken}");
      // debugPrint("ID Token: ${auth.idToken}");

      // Récupérer les infos
      final String username = user.displayName ?? "NoName";
      final String avatarUrl = user.photoUrl ?? "";
      final String bio = "Hello";
      final int roleId = 1;
      final String tokenOauth = auth.accessToken ?? "";
      print("##########################################");
      if (checkProfile(user.email) == false) {
      print("##########################################ENTERED");
        final Uri url = Uri.parse("https://epiflipboard-iau1.onrender.com/createProfile");
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": username,
            "avatar_url": avatarUrl,
            "bio": bio,
            "role_id": roleId,
            "token_oauth": tokenOauth,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint("✅ Profile créé: $data");
        } else {
          debugPrint("❌ Erreur API: ${response.statusCode}");
        }
      }

      Navigator.pushReplacementNamed(context, '/');

      } catch (e) {
        debugPrint("❌ GOOGLE AUTH ERROR: $e");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Titre
              Text(
                isSignUp ? "SIGN UP TO SAVE YOUR\nINTERESTS" : "WELCOME BACK",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              // Sous-titre
              Text(
                isSignUp ? "Get the most out of Flipboard" : "Please log in to continue",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              // Bouton Email
              // _AuthButton(
              //   icon: Icons.email_outlined,
              //   label: "Email",
              //   color: Colors.grey[800]!,
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => EmailAuthPage(isSignUp: isSignUp),
              //       ),
              //     );
              //   },
              // ),

              const SizedBox(height: 12),

              // Bouton Google
              _AuthButton(
                icon: Icons.g_mobiledata,
                label: "Google",
                color: const Color(0xFFDB4437),
                onTap: () => _googleOAuth(context),
              ),

              const SizedBox(height: 12),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isSignUp ? "Already have an account? " : "Don't have an account? ",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSignUp = !isSignUp;
                      });
                    },
                    child: Text(
                      isSignUp ? "Log in" : "Sign up",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Terms & Privacy
              Text.rich(
                TextSpan(
                  text: "By continuing, you accept the ",
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                  children: [
                    TextSpan(
                      text: "Terms of Use",
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget pour les boutons d'authentification
class _AuthButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AuthButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
