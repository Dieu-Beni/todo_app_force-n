import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum TaskPriority { ELEVE, MOYENNE, BASSE }
enum TaskEtat { FINI, ENCOURS }

class Task extends Equatable {
  final String id;
  final String titre;
  final String contenu;
  final DateTime date;
  final TaskPriority priorite;
  final TaskEtat etat;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.date,
    required this.priorite,
    required this.etat,
    this.isCompleted = false,
  });

  Color get color {
    switch (priorite) {
      case TaskPriority.ELEVE:
        return const Color(0xFFFEE2E2);
      case TaskPriority.MOYENNE:
        return const Color(0xFFFEF3C7);
      case TaskPriority.BASSE:
        return const Color(0xFFD1FAE5);
    }
  }

  Color get priorityColor {
    switch (priorite) {
      case TaskPriority.ELEVE:
        return const Color(0xFFEF4444);
      case TaskPriority.MOYENNE:
        return const Color(0xFFF59E0B);
      case TaskPriority.BASSE:
        return const Color(0xFF0335D2);
    }
  }

  String get priorityLabel {
    switch (priorite) {
      case TaskPriority.ELEVE:
        return 'Elevée';
      case TaskPriority.MOYENNE:
        return 'Moyenne';
      case TaskPriority.BASSE:
        return 'Basse';
    }
  }

  Task copyWith({
    String? id,
    String? titre,
    String? contenu,
    DateTime? date,
    TaskPriority? priorite,
    TaskEtat? etat,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      contenu: contenu ?? this.contenu,
      date: date ?? this.date,
      priorite: priorite ?? this.priorite,
      etat: etat ?? this.etat,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, titre, contenu, date, priorite, etat, isCompleted];
}
