import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_now/src/features/auth/domain/app_user.dart';
import 'package:do_now/src/features/group/domain/group.dart';
import 'package:do_now/src/features/todo/domain/todo.dart';

import 'database_repository.dart';

class FirestoreRepository implements DatabaseRepository {
  final fs = FirebaseFirestore.instance;

  @override
  Future<List<Group>> getGroups(String userId) async {
    final snaps = await fs
        .collection('groups')
        .where('memberIds', arrayContains: userId)
        .get();
    return snaps.docs.map((e) {
      return Group.fromMap(e.data());
    }).toList();
  }

  @override
  Future<void> createGroup(String userId, Group group) async {
    await fs.collection('groups').doc(group.id).set(group.toMap());
  }

  @override
  Future<void> deleteGroup(String userId, String groupId) async {
    await fs.collection('groups').doc(groupId).delete();
  }

  @override
  Future<void> checkTodo(String groupId, String todoId) async {
    await fs
        .collection('groups')
        .doc(groupId)
        .collection('todos')
        .doc(todoId)
        .update({'isDone': true});
  }

  @override
  Future<void> uncheckTodo(String groupId, String todoId) async {
    await fs
        .collection('groups')
        .doc(groupId)
        .collection('todos')
        .doc(todoId)
        .update({'isDone': false});
  }

  @override
  Future<void> createTodo(String groupId, Todo todo) async {
    await fs
        .collection('groups')
        .doc(groupId)
        .collection('todos')
        .doc(todo.id)
        .set(todo.toMap());
  }

  @override
  Future<List<Todo>> getTodos(String groupId) async {
    final snaps = await fs
        .collection('groups')
        .doc(groupId)
        .collection('todos')
        .get();
    return snaps.docs.map((e) {
      return Todo.fromMap(e.data());
    }).toList();
  }

  @override
  Future<AppUser> getUser(String userId) async {
    final snap = await fs.collection('users').doc(userId).get();
    return AppUser.fromMap(snap.data()!);
  }

  @override
  Future<void> createAppUser(AppUser appUser) async {
    await fs.collection('users').doc(appUser.id).set(appUser.toMap());
  }

  @override
  Future<Group> joinGroup(String userId, String groupId) async {
    await fs.collection('groups').doc(groupId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
    });
    final snap = await fs.collection('groups').doc(groupId).get();
    return Group.fromMap(snap.data()!);
  }
}
