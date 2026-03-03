class Task {
  String title;    // Le titre 
  String content;  // Le contenu 
  DateTime date;   // La date et l'heure 
  String priority; // Élevée, Moyenne, Basse 

  Task({
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
  });
}