import 'package:api/jwt/domain/use_case/token_interactor.dart';
import 'package:common/usecase/usecase.dart';

final class ForceRefreshJwtTokensUseCase extends UseCase<EmptyUseCaseResult, EmptyUsecaseParams>{
  final TokenInteractor interactor;

  ForceRefreshJwtTokensUseCase(this.interactor);

  @override
  Future<UseCaseResult<EmptyUseCaseResult>> call(EmptyUsecaseParams params) => innerCall(() async{
    await interactor.refreshToken();
    return const EmptyUseCaseResult();
  });
}