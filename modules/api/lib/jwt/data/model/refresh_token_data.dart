import 'package:api/jwt/domain/entity/refresh_token_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_data.g.dart';

/// Класс для сохранения данных о  рефреш токене
@JsonSerializable()
class RefreshTokenData {
  final String refreshToken;
  final int expiresInDate;

  RefreshTokenData({
    required this.refreshToken,
    required this.expiresInDate,
  });

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) {
    return _$RefreshTokenDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RefreshTokenDataToJson(this);

  factory RefreshTokenData.fromInfo(RefreshTokenInfo tokenInfo) => RefreshTokenData(refreshToken: tokenInfo.token, expiresInDate: tokenInfo.expiredInDate.millisecondsSinceEpoch);

  RefreshTokenInfo toTokenInfo() => RefreshTokenInfo(token: refreshToken, expiredInDate: DateTime.fromMillisecondsSinceEpoch(expiresInDate));
}
