import 'package:do_now/src/features/auth/domain/app_user.dart';

class Group {
  // Attribute
  final String id;
  final String name;
  final List<AppUser> members;
  final String creatorId;

  // Konstruktor
  Group({
    required this.id,
    required this.name,
    required this.members,
    required this.creatorId,
  });

  // Methoden
  AppUser? getCreator() {
    for (AppUser user in members) {
      // is user creator?
      if (user.id == creatorId) {
        return user;
      }
    }
    return null;
  }
}
