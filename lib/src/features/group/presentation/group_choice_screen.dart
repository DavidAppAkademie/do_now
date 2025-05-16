import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/group/domain/group.dart';
import 'package:do_now/src/features/group/presentation/group_choice_card.dart';
import 'package:do_now/src/features/todo/presentation/home_screen.dart';
import 'package:flutter/material.dart';

class GroupChoiceScreen extends StatelessWidget {
  // Attribute
  final DatabaseRepository db;

  // Konstruktor
  const GroupChoiceScreen(this.db, {super.key});

  // Methode(n)
  @override
  Widget build(BuildContext context) {
    final List<Group> myGroups = db.getGroups("1");

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
                            child: ListView.builder(
                              itemCount: myGroups.length,
                              itemBuilder: (context, index) {
                                final Group group = myGroups[index];
                                return ListTile(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeScreen(db, group.id)),
                                    );
                                  },
                                  title: Text(group.name),
                                  subtitle: Text("Code: ${group.groupCode}"),
                                  trailing: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.delete,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      )),
                                );
                              },
                            ),
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
