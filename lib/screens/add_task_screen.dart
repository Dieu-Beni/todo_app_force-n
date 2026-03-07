import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // 1. Les contrôleurs pour récupérer ce que l'utilisateur tape
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedPriority = 'Moyenne'; // Valeur par défaut pour la priorité

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une tâche"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Permet de faire défiler si le clavier cache l'écran
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Champ de saisie pour le Titre (Livrable 2)
              const Text("Titre de la tâche", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: "Ex: Finir le rapport"),
              ),
              const SizedBox(height: 20),

              // Champ de saisie pour le Contenu/Description (Livrable 2)
              const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _descriptionController,
                maxLines: 3, // Plus d'espace pour le texte
                decoration: const InputDecoration(hintText: "Détails de la tâche..."),
              ),
              const SizedBox(height: 20),

              // Menu déroulant pour la Priorité (Livrable 2)
              const Text("Niveau de priorité", style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _selectedPriority,
                isExpanded: true,
                items: <String>['Haute', 'Moyenne', 'Basse'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPriority = newValue!; // Met à jour l'affichage
                  });
                },
              ),
              const SizedBox(height: 40),

              // Bouton pour valider la création
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A)),
                  onPressed: () {
                    // Pour l'instant, on affiche juste les infos dans la console
                    print("Tâche : ${_titleController.text}");
                    Navigator.pop(context); // Retourne à l'écran précédent
                  },
                  child: const Text("Enregistrer la tâche", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}