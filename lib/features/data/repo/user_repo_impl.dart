import 'package:hivecaching/features/data/dataservice/dataservice.dart';
import 'package:hivecaching/features/domain/model/users.dart';
import 'package:hivecaching/features/domain/repo/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final Dataservice dataservice;
  UserRepoImpl(this.dataservice);

  @override
  Future<List<Users>> getAllUsers(int page, int limit) {
    return dataservice.getUsers(page, limit);
  }

  @override
  List<Users> getCachedUsers() {
    return dataservice.userBox.values.toList();
  }
}
