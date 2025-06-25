import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/todo/domain/todo.dart';
import 'package:do_now/src/features/todo/presentation/add_todo_screen.dart';
import 'package:do_now/src/features/todo/presentation/widgets/date_container.dart';
import 'package:do_now/src/features/todo/presentation/widgets/todo_card.dart';
import 'package:do_now/src/theme/palette.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  // Attribute
  final DatabaseRepository db;
  final String groupId;
  final String groupName;

  // Konstruktor
  const HomeScreen(this.db, this.groupId, {super.key, required this.groupName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Todo>>? _myTodos;

  @override
  void initState() {
    super.initState();
    _myTodos = widget.db.getTodos(widget.groupId);
  }

  // Methode(n)
  @override
  Widget build(BuildContext context) {
    //List<Todo> myTodos = widget.db.getTodos(widget.groupId);

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
                  Expanded(
                    child: Text(
                      widget.groupName,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Palette.white,
                          ),
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
            MaterialPageRoute(
              builder: (context) => AddTodoScreen(
                widget.db,
                onTodoAdded: () {
                  setState(() {
                    _myTodos = widget.db.getTodos(widget.groupId);
                  });
                },
                groupId: widget.groupId,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: FutureBuilder(
            future: _myTodos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("Fehler: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  List<Todo> myTodos = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: myTodos.length,
                    itemBuilder: (context, index) {
                      final Todo todo = myTodos[index];
                      return Dismissible(
                        key: Key(todo.id),
                        child: TodoCard(
                          title: todo.title,
                          subTitle: todo.description,
                          icon: todo.icon.icon,
                          color: todo.color,
                          priority: todo.priority,
                          isDone: todo.isDone,
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            // von links nach rechts
                            // todo abhaken
                            await widget.db.checkTodo(widget.groupId, todo.id);
                          } else if (direction == DismissDirection.endToStart) {
                            // von rechts nach links
                            // todo enthaken
                            await widget.db
                                .uncheckTodo(widget.groupId, todo.id);
                          }
                          setState(() {});

                          return false;
                        },
                      );
                    },
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            }),
      ),
    );
  }
}
