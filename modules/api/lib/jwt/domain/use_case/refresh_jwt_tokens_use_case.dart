import 'package:api/jwt/domain/entity/token_pair_info.dart';

abstract interface class RefreshJwtTokensUseCase{
  Future<TokenPairInfo> refreshTokens({required String refreshToken});
}