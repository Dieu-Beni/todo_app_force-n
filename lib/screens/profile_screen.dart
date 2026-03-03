import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: const Color(0xFF1E3A8A), // Bleu du design
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            // Information : Nom
            const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text("Nom Complet"),
              subtitle: Text("Khadim"), 
            ),
            // Information : Email
            const ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text("Email"),
              subtitle: Text("khadim@exemple.com"),
            ),
            const Spacer(),
            // Bouton de modification demandé au Livrable 5
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF1E3A8A),
              ),
              child: const Text("Modifier mes informations", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}