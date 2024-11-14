import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

mixin Client {
  static Dio get(String baseUrl) {
    final dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(responseBody: true));
    }

    return dio;
  }
}
