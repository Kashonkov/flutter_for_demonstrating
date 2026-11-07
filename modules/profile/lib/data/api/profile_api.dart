import 'package:api/api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:profile/data/model/profile_dto.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(ApiClient client) => _ProfileApi(client.dio);

  @GET('/api/user/me')
  Future<ProfileDto> getUser();

  @GET('/api/user/{id}')
  Future<ProfileDto> updateUser(@Path() String id, @Body() ProfileDto userInfo);
}
