import 'package:api/jwt/domain/entity/access_token_info.dart';
import 'package:api/jwt/domain/entity/refresh_token_info.dart';

final class TokenPairInfo{
  final AccessTokenInfo accessToken;
  final RefreshTokenInfo refreshToken;

  TokenPairInfo({required this.accessToken, required this.refreshToken});
}