import 'package:common/index.dart';
import 'package:profile/domain/entity/profile_entity.dart';
import 'package:profile/domain/repository/profile_repository.dart';

final class GetProfileUseCase extends UseCase<ProfileEntity, GetProfileUseCaseParams> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<UseCaseResult<ProfileEntity>> call(GetProfileUseCaseParams params) =>
      innerCall(() => repository.getProfile(params.needUpdate));
}

final class GetProfileUseCaseParams{
  final bool needUpdate;

  GetProfileUseCaseParams(this.needUpdate);
}
