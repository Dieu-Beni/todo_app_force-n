import 'package:flutter/material.dart';
import 'screens/add_task_screen.dart';

void main() {
runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
const TodoApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Todo App Force-N',
theme: ThemeData(
primaryColor: const Color(0xFF043686),
appBarTheme: const AppBarTheme(
backgroundColor: Color(0xFF043686),
foregroundColor: Colors.white,
),
),
home: AddTaskScreen(),
);
}
}