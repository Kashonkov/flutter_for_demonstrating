import 'package:api/jwt/domain/entity/token_pair_info.dart';
import 'package:api/jwt/domain/use_case/token_interactor.dart';
import 'package:common/index.dart';

//Юзкейс для принудительного установки пары токенов
final class ForceSetJwtTokensUseCase extends UseCase<EmptyUseCaseResult, TokenPairInfo>{
  final TokenInteractor interactor;

  ForceSetJwtTokensUseCase(this.interactor);

  @override
  Future<UseCaseResult<EmptyUseCaseResult>> call(TokenPairInfo tokenPairInfo) => innerCall(() async{
    await interactor.forceSetToken(tokenPairInfo);
    return const EmptyUseCaseResult();
  });
}