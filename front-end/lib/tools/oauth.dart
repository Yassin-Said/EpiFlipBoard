import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
);

Future<void> signInWithGoogle() async {
  try {
    final user = await _googleSignIn.signIn();
    print("User email: ${user?.email}");
    print("User name: ${user?.displayName}");
    print("Photo URL: ${user?.photoUrl}");
  } catch (e) {
    print("Erreur Google sign-in: $e");
  }
}