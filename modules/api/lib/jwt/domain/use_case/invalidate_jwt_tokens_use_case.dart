import 'package:api/jwt/domain/use_case/token_interactor.dart';
import 'package:common/index.dart';

final class InvalidateJwtTokenUseCase extends UseCase<EmptyUseCaseResult, EmptyUsecaseParams>{
  final TokenInteractor interactor;

  InvalidateJwtTokenUseCase(this.interactor);

  @override
  Future<UseCaseResult<EmptyUseCaseResult>> call(EmptyUsecaseParams params) => innerCall(() async{
    await interactor.invalidateTokens();
    return const EmptyUseCaseResult();
  });
}