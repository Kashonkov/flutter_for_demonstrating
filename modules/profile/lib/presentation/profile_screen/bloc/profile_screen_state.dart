import 'package:profile/domain/entity/profile_entity.dart';

sealed class ProfileScreenState {}

final class ProfileScreenLoadingState extends ProfileScreenState {}

final class EmptyDataState extends ProfileScreenState {
  final String? version;

  EmptyDataState({this.version});
}

final class ProfileDataState extends ProfileScreenState {
  final ProfileEntity profile;
  final String? version;

  ProfileDataState({required this.profile, this.version});
}
