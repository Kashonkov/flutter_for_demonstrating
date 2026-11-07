import 'package:auth/navigation/auth_router.gr.dart';
import 'package:lxe_app/router/app_router.dart';
import 'package:order/navigation/order_router.gr.dart';
import 'package:profile/navigation/external_profile_navigator.dart';

final class ExternalProfileNavigatorImpl extends ExternalProfileNavigator {
  final AppRouter router;

  ExternalProfileNavigatorImpl(this.router);

  @override
  void navigateToLogout() {
    router.replaceAll([LoginRoute()]);
  }

  @override
  void navigateToOrders() {
    router.push(OrderListRoute());
  }
}
