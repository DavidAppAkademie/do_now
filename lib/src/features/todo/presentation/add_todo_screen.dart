import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/todo/domain/todo.dart';
import 'package:do_now/src/features/todo/presentation/widgets/color_slider.dart';
import 'package:do_now/src/features/todo/presentation/widgets/priority_slider.dart';
import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  // Attribute
  final DatabaseRepository db;

  // Konstruktor
  const AddTodoScreen(this.db, {super.key});

  // Methoden
  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  Color _selectedColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: _selectedColor),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('Neues Todo')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 16,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Titel",
                    hintText: "Titel eingeben",
                  ),
                ),
                TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Beschreibung",
                    hintText: "Beschreibung eingeben",
                  ),
                ),
                PrioritySlider(),
                ColorSlider(
                  onColorSelected: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final Todo todo = Todo(
                        id: "123",
                        groupId: "111",
                        title: "Beispiel Titel",
                        description: "Lorem ipsum dolor",
                        priority: Priority.high,
                        color: _selectedColor,
                        isDone: false,
                        dueDate: DateTime.now().add(Duration(days: 1)),
                      );

                      widget.db.createTodo(todo.groupId, todo);

                      Navigator.pop(context);
                    },
                    child: Text("Todo erstellen"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* 
Firebase User:
- ID
- Email
- Passwort
- URL zum Profilbild (falls mit Google Signin)


AppUser (Datenbank, also entweder Mock.., oder Firestore)

- ID
- Email
- URL zum Profilbild (falls mit Google Signin)
- Vorname
- Nachname
- Geburtsdatum
- Adresse


- Ablauf beim Registrieren
  1. Firebase User wird erstellt
  2. AppUser wird in Datenbank erstellt









 */
