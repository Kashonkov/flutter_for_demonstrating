import 'package:profile/domain/entity/avatar_source.dart';
import 'package:profile/domain/entity/profile_entity.dart';

abstract interface class ProfileRepository {
  Future<ProfileEntity> getProfile(bool needUpdate);

  Future<Stream<ProfileEntity?>> getProfileStream();

  Future<ProfileEntity> updateProfile(ProfileEntity profile);

  Future<String?> getAppVersion();

  Future<String?> getAvatar(AvatarSource source);
}
