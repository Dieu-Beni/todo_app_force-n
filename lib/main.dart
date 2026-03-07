import 'package:flutter/material.dart';
import 'screens/profile_screen.dart'; // Importation de ton écran

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProfileScreen(), // On affiche ton écran de profil au démarrage
    );
  }
}