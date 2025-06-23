import 'package:do_now/src/features/auth/domain/app_user.dart';
import 'package:do_now/src/features/group/domain/group.dart';
import 'package:do_now/src/features/todo/domain/todo.dart';

abstract class DatabaseRepository {
  // Groups
  Future<List<Group>> getGroups(String userId);
  Future<void> createGroup(String userId, Group group);
  Future<void> deleteGroup(String userId, String groupId);
  Future<Group> joinGroup(String userId, String groupId);

  // Todos
  Future<List<Todo>> getTodos(String groupId);
  Future<void> createTodo(String groupId, Todo todo);
  Future<void> checkTodo(String groupId, String todoId);
  Future<void> uncheckTodo(String groupId, String todoId);

  // AppUser
  Future<void> createAppUser(AppUser appUser);
  Future<AppUser> getUser(String userId);
}
