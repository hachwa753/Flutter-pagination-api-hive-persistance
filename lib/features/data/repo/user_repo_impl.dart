import 'package:dartz/dartz.dart';
import 'package:hivecaching/features/data/datasource/api_service.dart';

import 'package:hivecaching/features/data/datasource/local_service.dart';
import 'package:hivecaching/features/domain/model/users.dart';
import 'package:hivecaching/features/domain/repo/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final ApiService apiService;
  final LocalService localService;
  UserRepoImpl(this.apiService, this.localService);

  // fetch api and updates hive
  @override
  Future<Either<String, List<Users>>> getAllUsers(int page, int limit) async {
    try {
      final cachedUsers = localService.getCachedUsers();
      if (page == 1 && cachedUsers.isNotEmpty) {
        //background fetch
        _fetchAndUpdate(page, limit);
        //return cached users immediately
        return Right(cachedUsers);
      }
      //else
      //other pages or empty cache -> fetch normally
      return await _fetchAndUpdate(page, limit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // get cached users instantly
  @override
  List<Users> getCachedUsers() {
    return localService.getCachedUsers();
  }

  Future<Either<String, List<Users>>> _fetchAndUpdate(
    int page,
    int limit,
  ) async {
    try {
      final apiUser = await apiService.fetchUsers(page: page, limit: limit);
      //save update hive
      await localService.saveUsers(apiUser);

      //returned full cached list after update
      return Right(localService.getCachedUsers());
    } catch (e) {
      return Left("Failed to fetch users: $e");
    }
  }
}
