import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/todo/domain/todo.dart';
import 'package:do_now/src/features/todo/presentation/add_todo_screen.dart';
import 'package:do_now/src/features/todo/presentation/widgets/date_container.dart';
import 'package:do_now/src/features/todo/presentation/widgets/todo_card.dart';
import 'package:do_now/src/theme/palette.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // Attribute
  final DatabaseRepository db;

  // Konstruktor
  const HomeScreen(this.db, {super.key});

  // Methode(n)
  @override
  Widget build(BuildContext context) {
    List<Todo> myTodos = db.getTodos("111");

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            spacing: 32,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DoNow",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Palette.white,
                        ),
                  ),
                  Text("Jun",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Palette.white,
                          )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DateContainer(day: "19", isToday: true),
                  DateContainer(day: "20", isToday: false),
                  DateContainer(day: "21", isToday: false),
                  DateContainer(day: "22", isToday: false),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.chevron_right,
                      color: Palette.white,
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/calendar.png',
                height: 130,
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 300,
        shadowColor: Theme.of(context).colorScheme.primary,
        elevation: 16,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen(db)),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: ListView.builder(
          itemCount: myTodos.length,
          itemBuilder: (context, index) {
            final Todo todo = myTodos[index];
            return TodoCard(
              title: todo.title,
              subTitle: todo.description,
              icon: Icons.percent,
              color: todo.color,
            );
          },
        ),
      ),
    );
  }
}
