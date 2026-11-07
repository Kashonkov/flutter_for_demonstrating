import 'package:auth/domain/entity/auth_info_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(createToJson: false)
final class LoginResponse {
  final String token;
  final String refreshToken;
  final int userId;
  final String username;
  final int expiresIn;

  LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.userId,
    required this.username,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  AuthInfoEntity toEntity() => AuthInfoEntity(
    token: token,
    refreshToken: refreshToken,
    userId: userId,
    username: username,
    expiresIn: expiresIn,
  );
}
