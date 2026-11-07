import 'package:auth/navigation/auth_router.gr.dart';
import 'package:lxe_app/router/app_router.dart';

abstract interface class SplashNavigator {
  void navigateToAuth();
  void navigateToMainScreen();
}

final class SplashNavigatorImpl implements SplashNavigator {
  final AppRouter router;

  SplashNavigatorImpl(this.router);

  @override
  void navigateToAuth() {
    router.replace(LoginRoute());
  }

  @override
  void navigateToMainScreen() {
    router.replaceAll([MainRoute()]);
  }
}
