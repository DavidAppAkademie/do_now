import 'package:do_now/src/features/todo/domain/todo.dart';
import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  // state
  double priorityValue = 1;

  // methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Beschreibung",
                  hintText: "Beschreibung eingeben",
                  border: OutlineInputBorder(),
                ),
              ),
              Slider(
                max: 2,
                divisions: 2,
                value: priorityValue,
                onChanged: (newValue) {
                  setState(() {
                    priorityValue = newValue;
                  });
                },
              ),
              Text(Priority.values[priorityValue.toInt()].name),
            ],
          ),
        ),
      ),
    );
  }
}
