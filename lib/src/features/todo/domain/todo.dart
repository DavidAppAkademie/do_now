import 'package:flutter/material.dart';

enum Priority {
  low("niedrig", "low"),
  medium("mittel", "middle"),
  high("hoch", "high");

  const Priority(this.german, this.english);

  final String german;
  final String english;
}

enum TodoIcon {
  sport(Icons.sports),
  food(Icons.dining),
  shopping(Icons.shopping_cart);

  const TodoIcon(this.icon);

  final IconData icon;
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
  final TodoIcon icon;

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
    required this.icon,
  });
}
