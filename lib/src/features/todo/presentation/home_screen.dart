import 'package:do_now/main.dart';
import 'package:do_now/src/features/todo/domain/todo.dart';
import 'package:do_now/src/features/todo/presentation/add_todo_screen.dart';
import 'package:do_now/src/features/todo/presentation/widgets/date_container.dart';
import 'package:do_now/src/features/todo/presentation/widgets/todo_card.dart';
import 'package:do_now/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  // Attribute

  final String groupId;
  final String groupName;

  // Konstruktor
  const HomeScreen(this.groupId, {super.key, required this.groupName});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // State
  Future<List<Todo>>? _myTodos;
  int _dayOffset = 0; // Offset from today (0 = today, 1 = tomorrow, etc.)
  DateTime? _selectedDate; // Ausgewähltes Datum

  @override
  void initState() {
    super.initState();
    _myTodos = ref.read(dbProvider).getTodos(widget.groupId);
    _selectedDate = DateTime.now(); // Setze heute als Standard
  }

  // Methode zum Navigieren zu nächsten Tagen
  void _navigateToNextDays() {
    setState(() {
      _dayOffset += 4; // Springe 4 Tage vorwärts
    });
  }

  // Methode zum Navigieren zu vorherigen Tagen
  void _navigateToPreviousDays() {
    setState(() {
      _dayOffset -= 4; // Springe 4 Tage rückwärts
    });
  }

  // Methode zum Auswählen eines Datums
  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  // Methode zum Generieren der Datum-Liste
  List<DateTime> _generateDates() {
    final today = DateTime.now();
    return List.generate(4, (index) {
      return today.add(Duration(days: _dayOffset + index));
    });
  }

  // Methode zum Formatieren des Monats und Jahres
  String _getMonthYearDisplay(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mär',
      'Apr',
      'Mai',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Okt',
      'Nov',
      'Dez',
    ];
    final currentYear = DateTime.now().year;
    final monthName = months[date.month - 1];

    // Zeige Jahr nur wenn es nicht das aktuelle Jahr ist
    if (date.year != currentYear) {
      return '$monthName ${date.year}';
    }
    return monthName;
  }

  // Methode zum Überprüfen ob ein Datum heute ist
  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.day == today.day &&
        date.month == today.month &&
        date.year == today.year;
  }

  // Methode zum Überprüfen ob ein Datum ausgewählt ist
  bool _isSelected(DateTime date) {
    if (_selectedDate == null) return false;
    return date.day == _selectedDate!.day &&
        date.month == _selectedDate!.month &&
        date.year == _selectedDate!.year;
  }

  // Methode zum Überprüfen ob Rückwärts-Navigation möglich ist
  bool _canNavigateBackward() {
    final today = DateTime.now();
    final firstVisibleDate = today.add(Duration(days: _dayOffset));
    return firstVisibleDate.isAfter(today);
  }

  // Methode(n)
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);
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
                  Text(
                    _getMonthYearDisplay(_generateDates().first),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Palette.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rückwärts-Navigation Button (nur anzeigen wenn möglich)
                  if (_canNavigateBackward())
                    IconButton(
                      onPressed: _navigateToPreviousDays,
                      icon: Icon(
                        Icons.chevron_left,
                        color: Palette.white,
                      ),
                    )
                  else
                    SizedBox(width: 48), // Platzhalter für symmetrisches Layout
                  // DateContainer widgets
                  ..._generateDates().map(
                    (date) => DateContainer(
                      day: date.day.toString(),
                      isToday: _isToday(date),
                      isSelected: _isSelected(date),
                      onTap: () => _selectDate(date),
                    ),
                  ),

                  // Vorwärts-Navigation Button
                  IconButton(
                    onPressed: _navigateToNextDays,
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
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(80)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTodoScreen(
                db,
                onTodoAdded: () {
                  setState(() {
                    _myTodos = db.getTodos(widget.groupId);
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
                if (myTodos.isEmpty) {
                  return Center(
                    child: Text(
                      "Keine Todos gefunden",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: myTodos.length,
                  itemBuilder: (context, index) {
                    final Todo todo = myTodos[index];
                    return Dismissible(
                      key: Key(todo.id),
                      secondaryBackground: Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.centerRight,
                        color: Palette.green,
                        child: Icon(Icons.check),
                      ),
                      background: Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.centerLeft,
                        color: Theme.of(context).colorScheme.error,
                        child: Icon(Icons.undo),
                      ),
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
                          // von rechts nach links
                          // todo enthaken
                          await db.uncheckTodo(widget.groupId, todo.id);
                        } else if (direction == DismissDirection.endToStart) {
                          // von links nach rechts
                          // todo abhaken
                          await db.checkTodo(widget.groupId, todo.id);
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
          },
        ),
      ),
    );
  }
}
