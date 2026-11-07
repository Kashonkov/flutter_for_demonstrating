import 'package:api/jwt/domain/entity/access_token_info.dart';
import 'package:api/jwt/domain/entity/refresh_token_info.dart';
import 'package:api/jwt/domain/entity/token_pair_info.dart';

abstract interface class JwtTokenRepository {
  Future<void> saveTokens(TokenPairInfo pair);

  AccessTokenInfo? getAccessToken();

  Future<RefreshTokenInfo?> getRefreshToken();

  Future<void> deleteTokens();
}
