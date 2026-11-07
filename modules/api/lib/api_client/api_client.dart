import 'package:dio/dio.dart';

abstract class ApiClient {
  final Dio dio;

  ApiClient(this.dio);
}
