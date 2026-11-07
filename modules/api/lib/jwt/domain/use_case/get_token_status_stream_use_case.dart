import 'package:api/jwt/domain/entity/token_status.dart';
import 'package:api/jwt/domain/use_case/token_interactor.dart';
import 'package:common/index.dart';

class GetTokenStatusStreamUseCase extends SyncUseCase<Stream<TokenStatus>, EmptyUsecaseParams> {
  final TokenInteractor interactor;

  GetTokenStatusStreamUseCase(this.interactor);

  @override
  UseCaseResult<Stream<TokenStatus>> call(EmptyUsecaseParams params) => innerCall(() => interactor.getStatusStream());
}
