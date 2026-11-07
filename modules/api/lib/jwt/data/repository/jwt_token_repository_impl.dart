import 'package:api/jwt/data/data_source/jwt_local_data_source.dart';
import 'package:api/jwt/data/model/refresh_token_data.dart';
import 'package:api/jwt/domain/entity/access_token_info.dart';
import 'package:api/jwt/domain/entity/refresh_token_info.dart';
import 'package:api/jwt/domain/entity/token_pair_info.dart';
import 'package:api/jwt/domain/repository/jwt_token_repository.dart';

final class JwtTokenRepositoryImpl implements JwtTokenRepository {
  final JwtLocalDataSource localDataSource;

  JwtTokenRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveTokens(TokenPairInfo pair) async {
    await localDataSource.saveRefreshTokenData(
        RefreshTokenData.fromInfo(pair.refreshToken));
    localDataSource.saveAccessToken(pair.accessToken);
  }

  @override
  AccessTokenInfo? getAccessToken() => localDataSource.getAccessToken();

  @override
  Future<RefreshTokenInfo?> getRefreshToken() async {
    final tokenData = await localDataSource.getRefreshTokenData();
    return tokenData?.toTokenInfo();
  }

  @override
  Future<void> deleteTokens() => localDataSource.deleteTokens();
}
