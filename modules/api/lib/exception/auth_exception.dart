import 'package:dio/dio.dart';

final class AuthTokenInvalidException extends DioException {
  AuthTokenInvalidException({required super.requestOptions});
}
