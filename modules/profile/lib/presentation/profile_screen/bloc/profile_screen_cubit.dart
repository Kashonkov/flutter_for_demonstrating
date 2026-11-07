import 'dart:async';

import 'package:common/bloc/base_cubit.dart';
import 'package:common/index.dart';
import 'package:profile/domain/entity/avatar_source.dart';
import 'package:profile/domain/entity/profile_entity.dart';
import 'package:profile/domain/use_case/get_app_version_use_case.dart';
import 'package:profile/domain/use_case/get_avatar_use_case.dart';
import 'package:profile/domain/use_case/get_profile_stream_use_case.dart';
import 'package:profile/domain/use_case/logout_use_case.dart';
import 'package:profile/domain/use_case/update_profile_use_case.dart';
import 'package:profile/navigation/profile_navigator.dart';
import 'package:profile/presentation/profile_screen/bloc/profile_screen_news.dart';
import 'package:profile/presentation/profile_screen/bloc/profile_screen_state.dart';

final class ProfileScreenCubit extends BaseCubit<ProfileScreenState> {
  final GetProfileStreamUseCase getProfileStreamUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetAppVersionUseCase getAppVersionUseCase;
  final GetAvatarUseCase getAvatarUseCase;
  final LogoutUseCase logoutUseCase;
  final ProfileNavigator navigator;

  StreamSubscription<ProfileEntity?>? _subscription;
  String? _version;

  ProfileScreenCubit({
    required this.getProfileStreamUseCase,
    required this.getAvatarUseCase,
    required this.getAppVersionUseCase,
    required this.logoutUseCase,
    required this.updateProfileUseCase,
    required this.navigator,
  }) : super(ProfileScreenLoadingState()) {
    _init();
  }

  void onLogoutTap() => _onLogout();

  void onContactSupportTap() => _onContactSupport();

  void onOrdersTap() => _navigateToOrders();

  void onSelectAvatarTap() => _selectAvatar();

  void onAvatarSourceSelected(AvatarSource source) => _onAvatarSourceSelected(source);

  void _init() async {
    await processUseCase(
      () => getAppVersionUseCase(EmptyUsecaseParams()),
      onSuccess: (version) {
        _version = version;
      },
    );
    processUseCase(
      () => getProfileStreamUseCase(EmptyUsecaseParams()),
      onSuccess: (result) => _processProfileStream(result),
      onError: (error) {
        emit(EmptyDataState());
        handleUseCaseError(error);
      },
    );
  }

  void _processProfileStream(Stream<ProfileEntity?> stream) {
    _subscription = stream.listen((profile) => _processProfile(profile));
  }

  void _processProfile(ProfileEntity? profile) {
    if (profile == null) {
      emit(EmptyDataState(version: _version));
    } else {
      emit(ProfileDataState(profile: profile, version: _version));
    }
  }

  void _onLogout() {
    processUseCase(
      () => logoutUseCase(EmptyUsecaseParams()),
      onSuccess: (_) {
        navigator.navigateToLogout();
      },
    );
  }

  void _navigateToOrders() {
    navigator.navigateToOrders();
  }

  void _onContactSupport() {}

  void _selectAvatar() {
    addNews(ShowAvatarSourceSelection());
  }

  void _onAvatarSourceSelected(AvatarSource source) async {
    processUseCase(
      () => getAvatarUseCase(source),
      onSuccess: (path) {
        if (path != null) {
          _updateAvatar(path);
        }
      },
    );
  }

  void _updateAvatar(String path) {
    processUseCase(
      () => updateProfileUseCase(UpdateProfileUseCaseParams(avatarPath: path)),
      onSuccess: (result) {},
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
