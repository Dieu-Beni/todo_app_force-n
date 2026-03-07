import 'package:flutter/material.dart';
import 'profile_screen.dart';

class AddTaskScreen extends StatefulWidget {
@override
_AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
final TextEditingController _titleController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
String _selectedPriority = 'Moyenne';

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Ajouter une tâche"),
actions: [
IconButton(
icon: const Icon(Icons.account_circle),
onPressed: () => Navigator.push(
context,
MaterialPageRoute(builder: (context) => ProfileScreen())
),
),
],
),
body: Padding(
padding: const EdgeInsets.all(20.0),
child: SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text("Titre", style: TextStyle(fontWeight: FontWeight.bold)),
TextField(controller: _titleController),
const SizedBox(height: 20),
const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
TextField(controller: _descriptionController, maxLines: 3),
const SizedBox(height: 20),
const Text("Priorité", style: TextStyle(fontWeight: FontWeight.bold)),
DropdownButton<String>(
value: _selectedPriority,
isExpanded: true,
items: ['Elevée', 'Moyenne', 'Basse'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
onChanged: (val) => setState(() => _selectedPriority = val!),
),
const SizedBox(height: 40),
SizedBox(
width: double.infinity,
child: ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF043686)),
onPressed: () => print("Enregistré"),
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