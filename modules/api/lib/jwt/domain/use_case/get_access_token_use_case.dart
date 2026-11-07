import 'package:api/jwt/domain/entity/access_token_info.dart';
import 'package:api/jwt/domain/repository/jwt_token_repository.dart';
import 'package:common/index.dart';

class GetAccessTokenUseCase extends SyncUseCase<AccessTokenInfo?, EmptyUsecaseParams> {
  final JwtTokenRepository repository;

  GetAccessTokenUseCase(this.repository);

  @override
  UseCaseResult<AccessTokenInfo?> call(EmptyUsecaseParams params) => innerCall(() => repository.getAccessToken());
}
