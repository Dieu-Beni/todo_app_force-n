import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.titre,
    required super.contenu,
    required super.date,
    required super.priorite,
    required super.etat,
    super.isCompleted,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      titre: json['titre'] as String,
      contenu: json['contenu'] as String,
      date: DateTime.parse(json['date'] as String),
      priorite: TaskPriority.values.firstWhere(
        (e) => e.name == json['priorite'],
        orElse: () => TaskPriority.MOYENNE,
      ),
      etat: TaskEtat.values.firstWhere(
            (e) => e.name == json['etat'],
        orElse: () => TaskEtat.ENCOURS,
      ),
      isCompleted: json['etat'] == TaskEtat.FINI.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'date': date.toIso8601String(),
      'priorite': priorite.name,
      'etat': etat.name,
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      titre: task.titre,
      contenu: task.contenu,
      date: task.date,
      priorite: task.priorite,
      etat: task.etat,
      isCompleted: task.isCompleted,
    );
  }
}
