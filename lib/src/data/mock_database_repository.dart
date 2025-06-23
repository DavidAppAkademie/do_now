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
      icon: TodoIcon.sport,
    ),
  ];
  final List<Group> _groupList = [
    Group(
      id: "111",
      name: "Family",
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
  Future<void> checkTodo(String groupId, String todoId) async {
    await Future.delayed(Duration(seconds: 5));
    _todoList.firstWhere((todo) => todo.id == todoId).isDone = true;
  }

  @override
  Future<void> createGroup(String userId, Group group) async {
    await Future.delayed(Duration(seconds: 5));
    _groupList.add(group);
  }

  @override
  Future<void> createTodo(String groupId, Todo todo) async {
    await Future.delayed(Duration(seconds: 5));
    _todoList.add(todo);
  }

  @override
  Future<void> deleteGroup(String userId, String groupId) async {
    await Future.delayed(Duration(seconds: 5));
    _groupList.removeWhere((group) => group.id == groupId);
  }

  @override
  Future<List<Group>> getGroups(String userId) async {
    await Future.delayed(Duration(seconds: 5));
    return _groupList
        .where((group) => group.members.map((m) => m.id).contains(userId))
        .toList();
  }

  @override
  Future<List<Todo>> getTodos(String groupId) async {
    await Future.delayed(Duration(seconds: 5));
    return _todoList.where((todo) => todo.groupId == groupId).toList();
  }

  @override
  Future<Group> joinGroup(String userId, String groupId) async {
    await Future.delayed(Duration(seconds: 5));
    final group = _groupList.firstWhere((group) => group.id == groupId);
    final user = _userList.firstWhere((user) => user.id == userId);
    group.members.add(user);
    return group;
  }

  @override
  Future<void> uncheckTodo(String groupId, String todoId) async {
    await Future.delayed(Duration(seconds: 5));
    _todoList.firstWhere((todo) => todo.id == todoId).isDone = false;
  }

  @override
  Future<void> createAppUser(AppUser appUser) async {
    await Future.delayed(Duration(seconds: 5));
    _userList.add(appUser);
  }

  @override
  Future<AppUser> getUser(String userId) async {
    await Future.delayed(Duration(seconds: 5));
    // Kurzschreibweise
    final AppUser appUser = _userList.firstWhere((user) => user.id == userId);
    return appUser;
  }
}
