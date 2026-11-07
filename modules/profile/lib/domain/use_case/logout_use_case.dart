import 'package:api/jwt/domain/use_case/invalidate_jwt_tokens_use_case.dart';
import 'package:common/index.dart';
import 'package:profile/domain/repository/profile_repository.dart';

final class LogoutUseCase extends UseCase<EmptyUseCaseResult, EmptyUsecaseParams> {
  final ProfileRepository repository;
  final InvalidateJwtTokenUseCase invalidateJwtTokenUseCase;

  LogoutUseCase(this.repository, this.invalidateJwtTokenUseCase);

  @override
  Future<UseCaseResult<EmptyUseCaseResult>> call(EmptyUsecaseParams params) => innerCall(() async {
    invalidateJwtTokenUseCase(EmptyUsecaseParams());
    return EmptyUseCaseResult();
  });
}
