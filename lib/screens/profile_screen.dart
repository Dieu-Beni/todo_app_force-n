import 'package:flutter/material.dart';
import 'add_task_screen.dart'; // IMPORTANT : Permet d'utiliser la page d'ajout

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre supérieure avec le titre demandé au Livrable 5
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: const Color(0xFF1E3A8A), // Bleu marine professionnel
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Marge tout autour du contenu
        child: Column(
          children: [
            // Photo de profil (icône par défaut)
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20), // Espace vertical entre les éléments
            
            // Bloc Information : Nom Complet
            const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text("Nom Complet"),
              subtitle: Text("Khadim"), 
            ),
            
            // Bloc Information : Email
            const ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text("Email"),
              subtitle: Text("khadim@exemple.com"),
            ),
            
            // Pousse le bouton vers le bas de l'écran
            const Spacer(),
            
            // Bouton de navigation vers l'ajout de tâches
            SizedBox(
              width: double.infinity, // Le bouton prend toute la largeur
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A), // Couleur bleue
                  foregroundColor: Colors.white, // Texte en blanc
                ),
                onPressed: () {
                  // Cette fonction permet de changer de page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTaskScreen()),
                  );
                },
                child: const Text("Ajouter une tâche"), // Texte du bouton
              ),
            ),
          ], // Fin de la liste d'enfants de Column
        ), // Fin de Column
      ), // Fin de Padding
    ); // Fin de Scaffold
  }
}