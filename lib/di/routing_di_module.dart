import 'package:auto_route/auto_route.dart';
import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:lxe_app/feature/main_screen/navigation/tab_navigation.dart';
import 'package:lxe_app/feature/splash/navigation/splash_navigator.dart';
import 'package:lxe_app/router/app_router.dart';

final class RoutingDiModule extends BaseDIModule{
  @override
  void updateInjections(GetIt instance) {
    final router = AppRouter();
    instance.registerSingleton<AppRouter>(router);
    instance.registerSingleton<StackRouter>(router);
    instance.registerSingleton<TabNavigator>(TabNavigator(getIt()));

    //Region navigators
    instance.registerFactory<SplashNavigator>(() => SplashNavigatorImpl(router));
  }

}