import 'package:common/index.dart';
import 'package:profile/domain/entity/avatar_source.dart';
import 'package:profile/domain/repository/profile_repository.dart';

final class GetAvatarUseCase extends UseCase<String?, AvatarSource> {
  final ProfileRepository repository;

  GetAvatarUseCase(this.repository);

  @override
  Future<UseCaseResult<String?>> call(AvatarSource params) =>
      innerCall(() async => repository.getAvatar(params));
}
