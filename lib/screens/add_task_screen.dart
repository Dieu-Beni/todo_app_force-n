import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une tâche"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: "Titre")), // Titre requis 
            const TextField(decoration: InputDecoration(labelText: "Contenu")), // Contenu requis 
            const SizedBox(height: 20),
            // Sélecteur de priorité (Élevée, Moyenne, Basse) 
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(value: "Haute", child: Text("Élevée")),
                DropdownMenuItem(value: "Moyenne", child: Text("Moyenne")),
                DropdownMenuItem(value: "Basse", child: Text("Basse")),
              ],
              onChanged: (value) {},
              decoration: const InputDecoration(labelText: "Priorité"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("Ajouter"),
            ),
          ],
        ),
      ),
    );
  }
}