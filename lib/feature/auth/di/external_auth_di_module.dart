import 'package:api/jwt/domain/use_case/refresh_jwt_tokens_use_case.dart';
import 'package:auth/di/auth_di_module.dart';
import 'package:auth/navigation/external_auth_navigator.dart';
import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:lxe_app/feature/api/jwt/refresh_jwt_tokens_use_case_impl.dart';
import 'package:lxe_app/feature/auth/navigation/external_auth_navigator_impl.dart';

final class ExternalAuthDiModule extends BaseDIModule {
  @override
  void updateInjections(GetIt instance) {
    instance.registerFactory<ExternalAuthNavigator>(() => ExternalAuthNavigatorImpl(getIt()));
    instance.installModule(AuthDiModule());
    final RefreshTokenHandlerRegistrar registrar = getIt();
    registrar.registerHandler(RefreshTokenHandlerImpl(getIt()));
  }
}
