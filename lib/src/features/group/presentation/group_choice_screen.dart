import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/group/domain/group.dart';
import 'package:do_now/src/features/group/presentation/group_choice_card.dart';
import 'package:do_now/src/features/todo/presentation/home_screen.dart';
import 'package:flutter/material.dart';

class GroupChoiceScreen extends StatefulWidget {
  // Attribute
  final DatabaseRepository db;

  // Konstruktor
  const GroupChoiceScreen(this.db, {super.key});

  @override
  State<GroupChoiceScreen> createState() => _GroupChoiceScreenState();
}

class _GroupChoiceScreenState extends State<GroupChoiceScreen> {
  Future<List<Group>>? _myGroup;

  @override
  void initState() {
    // TODO: implement initState
    _myGroup = widget.db.getGroups("1");
    super.initState();
  }

  // Methode(n)
  @override
  Widget build(BuildContext context) {
    //final List<Group> myGroups = widget.db.getGroups("1");

    return Scaffold(
      appBar: AppBar(
        title: Text("Gruppe wählen"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              GroupChoiceCard(
                  title: "Neue Gruppe",
                  hintText: "Gruppenbezeichnung",
                  tipText: "Erstelle z.B. Einkaufen oder Familie",
                  buttonText: "Erstellen"),
              GroupChoiceCard(
                  title: "Gruppe beitreten",
                  hintText: "Code eingeben",
                  tipText: "",
                  buttonText: "Beitreten"),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        spacing: 16,
                        children: [
                          Text("Gruppe auswählen",
                              style: Theme.of(context).textTheme.titleMedium),
                          Expanded(
                            child: FutureBuilder(
                                future: _myGroup,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return Text("Fehler: ${snapshot.error}");
                                    } else if (snapshot.hasData) {
                                      List<Group> myGroups =
                                          snapshot.data ?? [];
                                      return ListView.builder(
                                        itemCount: myGroups.length,
                                        itemBuilder: (context, index) {
                                          final Group group = myGroups[index];
                                          return ListTile(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen(widget.db,
                                                            group.id)),
                                              );
                                            },
                                            title: Text(group.name),
                                            subtitle: Text(
                                                "Code: ${group.groupCode}"),
                                            trailing: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                )),
                                          );
                                        },
                                      );
                                    }
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  return Text("Keine Daten verfügbar");
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
