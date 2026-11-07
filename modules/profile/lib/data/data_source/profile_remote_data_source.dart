import 'package:api/exception/error_handler.dart';
import 'package:profile/data/api/profile_api.dart';
import 'package:profile/data/model/profile_dto.dart';
import 'package:profile/domain/entity/profile_entity.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileEntity> getProfile();

  Future<ProfileEntity> updateProfile({required ProfileEntity profile});
}

final class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApi _api;

  ProfileRemoteDataSourceImpl(this._api);

  @override
  Future<ProfileEntity> getProfile() async {
    final result = await checkNetErrors(() => _api.getUser());
    return result.toEntity();
  }

  @override
  Future<ProfileEntity> updateProfile({required ProfileEntity profile}) async {
    final result = await checkNetErrors(
      () => _api.updateUser(profile.id, ProfileDto.fromEntity(profile)),
    );
    return result.toEntity();
  }
}
