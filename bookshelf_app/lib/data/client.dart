import 'package:dio/dio.dart';

mixin Client {
  static Dio get(String baseUrl) {
    final dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers = {'Content-Type': 'application/json'};

    return dio;
  }
}
