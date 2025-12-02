import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tools/icon_button.dart';

class NotificationPage extends StatelessWidget {
    const NotificationPage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Notifications",style: GoogleFonts.archivoBlack(fontSize: 30)),
                actions: [
                    UniversalButton(icon: Icons.refresh,
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