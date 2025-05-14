import 'dart:ui';

enum Priority {
  low("niedrig", "low"),
  medium("mittel", "middle"),
  high("hoch", "high");

  const Priority(this.german, this.english);

  final String german;
  final String english;
}

class Todo {
  // Attribute
  final String id;
  final String groupId;
  final String title;
  final String description;
  final Priority priority;
  final Color color;
  bool isDone;
  final DateTime dueDate;

  // Konstruktor
  Todo({
    required this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.priority,
    required this.color,
    required this.isDone,
    required this.dueDate,
  });
}
