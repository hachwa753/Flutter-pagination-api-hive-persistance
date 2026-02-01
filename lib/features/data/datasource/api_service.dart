import 'package:dio/dio.dart';
import 'package:hivecaching/core/network/dio_client.dart';
import 'package:hivecaching/features/domain/model/users.dart';

class ApiService {
  final Dio dio = DioClient.instance;

  Future<List<Users>> fetchUsers({
    required int page,
    required int limit,
  }) async {
    final response = await dio.get(
      '/users',
      queryParameters: {'_page': page, '_limit': limit},
    );

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => Users.fromMap(e)).toList();
    } else {
      throw Exception("Failed to fetch users: ${response.statusCode}");
    }
  }
}
