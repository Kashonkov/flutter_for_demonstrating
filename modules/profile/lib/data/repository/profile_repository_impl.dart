import 'package:profile/data/data_source/platform_data_source.dart';
import 'package:profile/data/data_source/profile_local_data_source.dart';
import 'package:profile/data/data_source/profile_remote_data_source.dart';
import 'package:profile/domain/entity/avatar_source.dart';
import 'package:profile/domain/entity/profile_entity.dart';
import 'package:profile/domain/repository/profile_repository.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;
  final PlatformDataSource platformDataSource;

  ProfileRepositoryImpl(this.localDataSource, this.remoteDataSource, this.platformDataSource);

  @override
  Future<String?> getAppVersion() => platformDataSource.getAppVersion();

  @override
  Future<ProfileEntity> getProfile(bool needUpdate) async {
    if (needUpdate) {
      return _renewProfile();
    } else {
      final profile = localDataSource.getProfile();
      if (profile != null) {
        return profile;
      } else {
        return _renewProfile();
      }
    }
  }

  Future<ProfileEntity> _renewProfile() async {
    final profile = await remoteDataSource.getProfile();
    localDataSource.saveProfile(profile);
    return profile;
  }

  @override
  Future<Stream<ProfileEntity?>> getProfileStream() async {
    final savedProfile = localDataSource.getProfile();
    if (savedProfile == null) {
      await _renewProfile();
    }
    return localDataSource.getProfileStream();
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) {
    localDataSource.saveProfile(profile);
    return remoteDataSource.updateProfile(profile: profile);
  }

  @override
  Future<String?> getAvatar(AvatarSource source) => platformDataSource.getAvatar(source);
}
