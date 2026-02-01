import 'package:dartz/dartz.dart';
import 'package:hivecaching/features/domain/model/users.dart';

abstract class UserRepo {
  Future<Either<String, List<Users>>> getAllUsers(int page, int limit);
  // get cached users
  List<Users> getCachedUsers();
}
