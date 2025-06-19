import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/todo/domain/todo.dart';
import 'package:do_now/src/features/todo/presentation/widgets/color_slider.dart';
import 'package:do_now/src/features/todo/presentation/widgets/priority_slider.dart';
import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  // Attribute
  final DatabaseRepository db;
  final void Function() onTodoAdded;
  final String groupId;

  // Konstruktor
  const AddTodoScreen(
    this.db, {
    super.key,
    required this.onTodoAdded,
    required this.groupId,
  });

  // Methoden
  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  // State
  Color _selectedColor = Colors.red;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Priority _selectedPriority = Priority.medium;
  bool _isLoading = false;

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
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Titel",
                    hintText: "Titel eingeben",
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Beschreibung",
                    hintText: "Beschreibung eingeben",
                  ),
                ),
                PrioritySlider(
                  onPriorityChanged: (p) {
                    _selectedPriority = p;
                  },
                ),
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
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final Todo todo = Todo(
                              id: "123",
                              groupId: widget.groupId,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              priority: _selectedPriority,
                              color: _selectedColor,
                              isDone: false,
                              dueDate: DateTime.now().add(Duration(days: 1)),
                            );

                            setState(() {
                              _isLoading = true;
                            });
                            await widget.db.createTodo(todo.groupId, todo);
                            widget.onTodoAdded();

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
