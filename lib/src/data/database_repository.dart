import 'package:do_now/src/features/auth/domain/app_user.dart';
import 'package:do_now/src/features/group/domain/group.dart';
import 'package:do_now/src/features/todo/domain/todo.dart';

abstract class DatabaseRepository {
  // Groups
  List<Group> getGroups(String userId);
  void createGroup(String userId, Group group);
  void deleteGroup(String userId, String groupId);
  void joinGroup(String userId, String groupId);

  // Todos
  List<Todo> getTodos(String groupId);
  void createTodo(String groupId, Todo todo);
  void checkTodo(String groupId, String todoId);
  void uncheckTodo(String groupId, String todoId);

  // AppUser
  void createAppUser(AppUser appUser);
  AppUser getUser(String userId);
}
