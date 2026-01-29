import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hivecaching/features/domain/model/users.dart';

class Dataservice {
  static final dio = Dio(
    BaseOptions(
      baseUrl: "https://jsonplaceholder.typicode.com",
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final Box<Users> userBox = Hive.box<Users>('usersBox');

  Future<List<Users>> getUsers(int page, int limit) async {
    //  //try to get cached users first
    //   final cachedUsers = userBox.values.toList();
    //   if (cachedUsers.isNotEmpty) {
    //     return cachedUsers;
    //   }
    //   //if not cached, fetched from api

    try {
      final response = await dio.get(
        '/users',
        queryParameters: {'_page': page, '_limit': limit},
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        final users = data.map((e) => Users.fromMap(e)).toList();

        if (page == 1) {
          await userBox.clear(); // first page = refresh
        }

        await userBox.addAll(users);

        // Always return full cached list
        return userBox.values.toList();
      } else {
        throw Exception("Failed to load users: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }
}
