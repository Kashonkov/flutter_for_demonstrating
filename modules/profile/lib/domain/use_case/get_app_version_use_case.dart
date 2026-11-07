import 'package:common/index.dart';
import 'package:profile/domain/repository/profile_repository.dart';

final class GetAppVersionUseCase extends UseCase<String?, EmptyUsecaseParams> {
  final ProfileRepository repository;

  GetAppVersionUseCase(this.repository);

  @override
  Future<UseCaseResult<String?>> call(EmptyUsecaseParams params) =>
      innerCall(() => repository.getAppVersion());
}
