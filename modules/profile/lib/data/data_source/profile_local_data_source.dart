import 'dart:async';

import 'package:profile/domain/entity/profile_entity.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class ProfileLocalDataSource {
  Stream<ProfileEntity?> getProfileStream();

  ProfileEntity? getProfile();

  void saveProfile(ProfileEntity profile);
}

final class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileEntity? _profile;
  final StreamController<ProfileEntity> _controller = BehaviorSubject();

  @override
  Stream<ProfileEntity?> getProfileStream() => _controller.stream;

  @override
  void saveProfile(ProfileEntity profile) {
    _profile = profile;
    _controller.add(profile);
  }

  @override
  ProfileEntity? getProfile() => _profile;
}
