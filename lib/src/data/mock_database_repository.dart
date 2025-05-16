import 'package:do_now/src/features/auth/domain/app_user.dart';
import 'package:do_now/src/features/group/domain/group.dart';
import 'package:do_now/src/features/todo/domain/todo.dart';
import 'package:flutter/material.dart';

import 'database_repository.dart';

class MockDatabaseRepository implements DatabaseRepository {
  // Simulierte Datenbanken
  final List<Todo> _todoList = [
    Todo(
      id: "1",
      groupId: "111",
      title: "Walk the dog",
      description: "Take the dog for a walk in the park",
      isDone: false,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: Priority.medium,
      color: Colors.red,
    ),
  ];
  final List<Group> _groupList = [
    Group(
      id: "111",
      name: "Family",
      groupCode: 1234,
      members: [
        AppUser(
          id: "1",
          name: "David",
          email: "david@web.de",
          photoUrl:
              "https://ca.slack-edge.com/T044YC3MSLF-U05GXAU2DH6-75f1f34f2c6f-48",
        ),
      ],
      creatorId: "1",
    ),
    Group(
      id: "112",
      name: "Einkaufen",
      groupCode: 8888,
      members: [
        AppUser(
          id: "1",
          name: "David",
          email: "david@web.de",
          photoUrl:
              "https://ca.slack-edge.com/T044YC3MSLF-U05GXAU2DH6-75f1f34f2c6f-48",
        ),
      ],
      creatorId: "1",
    ),
  ];
  final List<AppUser> _userList = [
    AppUser(
      id: "1",
      name: "David",
      email: "david@web.de",
      photoUrl:
          "https://ca.slack-edge.com/T044YC3MSLF-U05GXAU2DH6-75f1f34f2c6f-48",
    ),
    AppUser(
      id: "2",
      name: "Hans",
      email: "david@web.de",
      photoUrl:
          "https://ca.slack-edge.com/T044YC3MSLF-U05GXAU2DH6-75f1f34f2c6f-48",
    ),
  ];

  @override
  void checkTodo(String groupId, String todoId) {
    _todoList.firstWhere((todo) => todo.id == todoId).isDone = true;
  }

  @override
  void createGroup(String userId, Group group) {
    _groupList.add(group);
  }

  @override
  void createTodo(String groupId, Todo todo) {
    _todoList.add(todo);
  }

  @override
  void deleteGroup(String userId, String groupId) {
    _groupList.removeWhere((group) => group.id == groupId);
  }

  @override
  List<Group> getGroups(String userId) {
    return _groupList
        .where((group) => group.members.map((m) => m.id).contains(userId))
        .toList();
  }

  @override
  List<Todo> getTodos(String groupId) {
    return _todoList.where((todo) => todo.groupId == groupId).toList();
  }

  @override
  void joinGroup(String userId, String groupId) {
    final group = _groupList.firstWhere((group) => group.id == groupId);
    final user = _userList.firstWhere((user) => user.id == userId);
    group.members.add(user);
  }

  @override
  void uncheckTodo(String groupId, String todoId) {
    _todoList.firstWhere((todo) => todo.id == todoId).isDone = false;
  }

  @override
  void createAppUser(AppUser appUser) {
    _userList.add(appUser);
  }

  @override
  AppUser getUser(String userId) {
    // Kurzschreibweise
    final AppUser appUser = _userList.firstWhere((user) => user.id == userId);
    return appUser;
  }
}
