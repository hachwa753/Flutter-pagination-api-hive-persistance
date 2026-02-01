import 'package:hive/hive.dart';
import 'package:hivecaching/features/domain/model/users.dart';

class LocalService {
  final Box<Users> userBox = Hive.box<Users>('usersBox');

  // get all cached users
  List<Users> getCachedUsers() => userBox.values.toList();

  // insert or update users
  Future<void> saveUsers(List<Users> users) async {
    //insert or update by unique id
    users.map((user) => userBox.put(user.id, user)).toList();
  }

  // clear cache
  Future<void> clearCache() async => await userBox.clear();
}
