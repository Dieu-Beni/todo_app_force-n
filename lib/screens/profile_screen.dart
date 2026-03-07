import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Mon Profil"),
actions: [
IconButton(
icon: const Icon(Icons.logout, color: Colors.redAccent),
onPressed: () => Navigator.pop(context),
),
],
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
const SizedBox(height: 30),
const ListTile(title: Text("Nom"), subtitle: Text("Khadim")),
const ListTile(title: Text("Email"), subtitle: Text("khadim@exemple.com")),
const Spacer(),
SizedBox(
width: double.infinity,
child: ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF043686)),
onPressed: () => print("Modifier"),
child: const Text("Modifier mes informations", style: TextStyle(color: Colors.white)),
),
),
],
),
),
);
}
}