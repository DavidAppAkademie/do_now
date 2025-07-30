import 'package:do_now/main.dart';
import 'package:do_now/src/features/auth/domain/app_user.dart';
import 'package:do_now/src/features/group/domain/group.dart';
import 'package:do_now/src/features/group/presentation/group_choice_card.dart';
import 'package:do_now/src/features/todo/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupChoiceScreen extends ConsumerStatefulWidget {
  final String userId;
  // Konstruktor
  const GroupChoiceScreen({super.key, required this.userId});

  @override
  ConsumerState<GroupChoiceScreen> createState() => _GroupChoiceScreenState();
}

class _GroupChoiceScreenState extends ConsumerState<GroupChoiceScreen> {
  // State
  Future<List<Group>>? _myGroup;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _myGroup = ref.read(dbProvider).getGroups(widget.userId);
  }

  // Methode(n)
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Gruppe wählen"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              children: [
                GroupChoiceCard(
                  title: "Neue Gruppe",
                  hintText: "Gruppenbezeichnung",
                  tipText: "Erstelle z.B. Einkaufen oder Familie",
                  buttonText: "Erstellen",
                  onPressed: (String value) async {
                    // AppUser bekommen
                    final AppUser user = await db.getUser(widget.userId);
                    // Gruppe erstellen
                    final String groupId = DateTime.now().millisecondsSinceEpoch
                        .toString();
                    await db.createGroup(
                      widget.userId,
                      Group(
                        id: groupId,
                        name: value,
                        members: [user],
                        creatorId: widget.userId,
                      ),
                    );

                    if (context.mounted) {
                      // zum Home Screen fuer diese erstellte Gruppe
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            groupId,
                            groupName: value,
                          ),
                        ),
                      );
                    }
                  },
                ),
                GroupChoiceCard(
                  title: "Gruppe beitreten",
                  hintText: "Code eingeben",
                  tipText: "",
                  buttonText: "Beitreten",
                  onPressed: (groupCode) async {
                    final group = await db.joinGroup(widget.userId, groupCode);
                    if (context.mounted) {
                      // zum Home Screen fuer diese beigetretene Gruppe
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            groupCode,
                            groupName: group.name,
                          ),
                        ),
                      );
                    }
                  },
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        spacing: 16,
                        children: [
                          Text(
                            "Gruppe auswählen",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          FutureBuilder(
                            future: _myGroup,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Text("Fehler: ${snapshot.error}");
                                } else if (snapshot.hasData) {
                                  List<Group> myGroups = snapshot.data ?? [];
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: myGroups.length,
                                    itemBuilder: (context, index) {
                                      final Group group = myGroups[index];
                                      return ListTile(
                                        onTap: _isLoading
                                            ? null
                                            : () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen(
                                                          group.id,
                                                          groupName: group.name,
                                                        ),
                                                  ),
                                                );
                                              },
                                        title: Text(group.name),
                                        subtitle: Text("Code: ${group.id}"),
                                        trailing: IconButton(
                                          onPressed: _isLoading
                                              ? null
                                              : () async {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  // 1. db deleteGroup
                                                  try {
                                                    await db.deleteGroup(
                                                      widget.userId,
                                                      group.id,
                                                    );
                                                    // 2. future neu setzen
                                                    setState(() {
                                                      _myGroup = db.getGroups(
                                                        widget.userId,
                                                      );
                                                    });
                                                  } catch (e) {
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            "Fehler beim Löschen der Gruppe: $e",
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  } finally {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  }
                                                },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Text("Keine Daten verfügbar");
                            },
                          ),
                        ],
                      ),
                    ),
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
