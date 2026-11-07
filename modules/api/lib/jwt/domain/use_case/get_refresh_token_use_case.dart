import 'package:api/jwt/domain/entity/refresh_token_info.dart';
import 'package:api/jwt/domain/repository/jwt_token_repository.dart';
import 'package:common/index.dart';

class GetRefreshTokenUseCase extends UseCase<RefreshTokenInfo?, EmptyUsecaseParams> {
  final JwtTokenRepository repository;

  GetRefreshTokenUseCase(this.repository);

  @override
  Future<UseCaseResult<RefreshTokenInfo?>> call(EmptyUsecaseParams params) => innerCall(() => repository.getRefreshToken());
}
