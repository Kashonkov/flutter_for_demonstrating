import 'package:api/jwt/domain/use_case/token_interactor.dart';
import 'package:common/index.dart';

/// Юзкей который необходимо вызвать перед использованием запросов потребляющих  оце  токен
final class InitJwtTokenAuthorizationUseCase
    extends UseCase<EmptyUseCaseResult, EmptyUsecaseParams> {
  final TokenInteractor interactor;

  InitJwtTokenAuthorizationUseCase(this.interactor);

  @override
  Future<UseCaseResult<EmptyUseCaseResult>> call(EmptyUsecaseParams params) => innerCall(() async {
    Exception? initError;
    await interactor.init(
      errorHandler: (exception) {
        initError = exception;
      },
    );
    if (initError != null) {
      throw initError ?? Exception();
    }
    return const EmptyUseCaseResult();
  });
}
