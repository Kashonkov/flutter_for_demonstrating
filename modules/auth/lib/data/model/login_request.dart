import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable(createFactory: false)
final class LoginRequest {
  final String login;
  final String password;

  LoginRequest({
    required this.login,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
