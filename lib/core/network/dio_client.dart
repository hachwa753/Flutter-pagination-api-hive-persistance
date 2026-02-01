import 'package:dio/dio.dart';

class DioClient {
  static final instance = Dio(
    BaseOptions(
      baseUrl: "https://jsonplaceholder.typicode.com",
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
