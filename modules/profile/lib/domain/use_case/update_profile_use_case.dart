import 'package:common/usecase/usecase.dart';
import 'package:profile/domain/entity/avatar_entity.dart';
import 'package:profile/domain/entity/profile_entity.dart';
import 'package:profile/domain/repository/profile_repository.dart';

final class UpdateProfileUseCase extends UseCase<ProfileEntity, UpdateProfileUseCaseParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<UseCaseResult<ProfileEntity>> call(params) => innerCall(() async {
    final currentProfile = await repository.getProfile(false);
    final updated = ProfileEntity(
      id: currentProfile.id,
      avatar: params.avatarPath != null
          ? FileAvatarEntity(filePath: params.avatarPath ?? "")
          : currentProfile.avatar,
      name: params.name ?? currentProfile.name,
      phone: params.phone ?? currentProfile.phone,
      email: params.email ?? currentProfile.email,
      company: params.company ?? currentProfile.company,
    );

    return repository.updateProfile(updated);
  });
}

final class UpdateProfileUseCaseParams {
  final String? avatarPath;
  final String? name;
  final String? phone;
  final String? email;
  final String? company;

  UpdateProfileUseCaseParams({this.avatarPath, this.name, this.phone, this.email, this.company});
}
