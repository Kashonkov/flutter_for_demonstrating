import 'package:json_annotation/json_annotation.dart';

part 'refresh_request.g.dart';

@JsonSerializable(createFactory: false)
final class RefreshRequest {
  final String refreshToken;

  RefreshRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => _$RefreshRequestToJson(this);
}
