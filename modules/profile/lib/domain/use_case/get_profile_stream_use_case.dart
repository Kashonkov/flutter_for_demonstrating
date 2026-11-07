import 'package:common/index.dart';
import 'package:profile/domain/entity/profile_entity.dart';
import 'package:profile/domain/repository/profile_repository.dart';

final class GetProfileStreamUseCase extends UseCase<Stream<ProfileEntity?>, EmptyUsecaseParams> {
  final ProfileRepository repository;

  GetProfileStreamUseCase(this.repository);

  @override
  Future<UseCaseResult<Stream<ProfileEntity?>>> call(EmptyUsecaseParams params) =>
      innerCall(() => repository.getProfileStream());
}
