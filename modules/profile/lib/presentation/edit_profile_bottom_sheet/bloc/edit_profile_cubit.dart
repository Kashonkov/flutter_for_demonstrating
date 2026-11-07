import 'package:common/bloc/base_cubit.dart';
import 'package:profile/domain/entity/profile_entity.dart';
import 'package:profile/domain/use_case/get_profile_use_case.dart';
import 'package:profile/domain/use_case/update_profile_use_case.dart';
import 'package:profile/presentation/edit_profile_bottom_sheet/bloc/edit_profile_news.dart';
import 'package:profile/presentation/edit_profile_bottom_sheet/bloc/edit_profile_state.dart';

final class EditProfileCubit extends BaseCubit<EditProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileEntity? _profile;

  EditProfileCubit(this.getProfileUseCase, this.updateProfileUseCase) : super(EditProfileState()) {
    _onInit();
  }

  void onSaveTap({required String name, required String phone, required String company}) =>
      _onSaveTap(name: name, phone: phone, company: company);

  Future<void> _onInit() async {
    await processUseCase(
      () => getProfileUseCase(GetProfileUseCaseParams(false)),
      onSuccess: (profile) {
        _profile = profile;
        addNews(
          SetProfileDataNews(
            name: profile.name,
            phone: profile.phone,
            email: profile.email,
            company: profile.company,
          ),
        );
      },
    );
  }

  void _onSaveTap({required String name, required String phone, required String company}) {
    if (_isInfoUpdated(name: name, phone: phone, company: company)) {
      updateProfileUseCase(UpdateProfileUseCaseParams(name: name, phone: phone, company: company));
    }
    addNews(NavigateBackNews());
  }

  bool _isInfoUpdated({required String name, required String phone, required String company}) {
    return _profile?.name != name || _profile?.phone != phone || _profile?.company != company;
  }
}
