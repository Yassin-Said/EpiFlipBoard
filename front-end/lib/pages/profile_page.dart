import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tools/icon_button.dart';

class ProfilePage extends StatelessWidget {
    const ProfilePage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Profil",style: GoogleFonts.archivoBlack(fontSize: 30)),
                actions: [
                    UniversalButton(icon: Icons.history,
                        onPressed: () {
                            print("Bouton cliqué !");
                        },
                    ),
                    UniversalButton(icon: Icons.refresh,
                        onPressed: () {
                            body:const Text("TEST");
                            print("Bouton cliqué !");
                        },
                    ),
                    UniversalButton(icon: Icons.settings,
                        onPressed: () {
                            print("Bouton cliqué !");
                        },
                    ),
                ]
            ),
            body: const Center(

            ),
        );
    }
}