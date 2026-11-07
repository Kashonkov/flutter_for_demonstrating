import 'package:api/api_client/api_client.dart';
import 'package:auth/data/model/login_request.dart';
import 'package:auth/data/model/login_response.dart';
import 'package:auth/data/model/refresh_request.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(ApiClient client) => _AuthApi(client.dio);

  @POST('/api/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest body);

  @POST('/api/auth/refresh')
  Future<LoginResponse> refresh(@Body() RefreshRequest body);
}
