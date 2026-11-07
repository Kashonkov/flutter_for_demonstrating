import 'package:auth/navigation/external_auth_navigator.dart';
import 'package:lxe_app/feature/main_screen/di/main_screen_di_views.dart';
import 'package:lxe_app/router/app_router.dart';

final class ExternalAuthNavigatorImpl extends ExternalAuthNavigator {
  final AppRouter router;

  ExternalAuthNavigatorImpl(this.router);

  @override
  void navigateFromLogin() {
    router.replaceAll([MainRoute()]);
  }
}
