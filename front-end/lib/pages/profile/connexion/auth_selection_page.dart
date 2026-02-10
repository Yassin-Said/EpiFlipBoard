import 'package:flutter/material.dart';
import 'package:epiflipboard/pages/profile/connexion/email_auth_page.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthSelectionPage extends StatelessWidget {
  final bool isSignUp; // true = Sign Up, false = Log In

  const AuthSelectionPage({
    super.key,
    this.isSignUp = true,
  });

    Future<void> _googleOAuth() async {
  try {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();

    if (user == null) {
      debugPrint("❌ Login annulé");
      return;
    }

    final GoogleSignInAuthentication auth = await user.authentication;

    debugPrint("✅ GOOGLE LOGIN SUCCESS");

    debugPrint("Name: ${user.displayName}");
    debugPrint("Email: ${user.email}");
    debugPrint("Photo: ${user.photoUrl}");

    debugPrint("Access Token: ${auth.accessToken}");
    debugPrint("ID Token: ${auth.idToken}");

    /*
      👉 ICI tu récupères :
        - user.displayName
        - user.email
        - user.photoUrl
        - auth.accessToken
        - auth.idToken

      Tu peux les envoyer vers ton backend plus tard.
    */
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
              // Bouton retour
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

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
              _AuthButton(
                icon: Icons.email_outlined,
                label: "Email",
                color: Colors.grey[800]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailAuthPage(isSignUp: isSignUp),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Bouton Google
              _AuthButton(
                icon: Icons.g_mobiledata,
                label: "Google",
                color: const Color(0xFFDB4437),
                onTap: () => _googleOAuth(),
              ),

              const SizedBox(height: 12),

              // Bouton Facebook
              _AuthButton(
                icon: Icons.facebook,
                label: "Facebook",
                color: const Color(0xFF4267B2),
                onTap: () => print("Facebook auth"),
              ),

              if (!isSignUp) ...[
                const SizedBox(height: 12),
                // Bouton Twitter (uniquement pour Log In)
                _AuthButton(
                  icon: Icons.flutter_dash, // Remplace par l'icône Twitter
                  label: "Twitter",
                  color: const Color(0xFF1DA1F2),
                  onTap: () => print("Twitter auth"),
                ),
              ],

              const Spacer(),

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
