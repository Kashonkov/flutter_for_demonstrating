import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:lxe_app/feature/profile/navigation/external_profile_navigator_impl.dart';
import 'package:profile/di/profile_di_module.dart';
import 'package:profile/navigation/external_profile_navigator.dart';

final class ExternalProfileDiModule extends BaseDIModule {
  @override
  void updateInjections(GetIt instance) {
    instance.registerFactory<ExternalProfileNavigator>(() => ExternalProfileNavigatorImpl(getIt()));
    instance.installModule(ProfileDiModule());
  }
}
