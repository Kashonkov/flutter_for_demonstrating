import 'package:auth/navigation/auth_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:incident/navigation/incident_router.dart';
import 'package:lxe_app/feature/main_screen/di/main_screen_di_views.dart';
import 'package:lxe_app/feature/main_screen/main_screen.dart';
import 'package:lxe_app/feature/main_screen/navigation/tab_navigation.dart';
import 'package:lxe_app/feature/splash/di/splash_di_view.dart';
import 'package:order/navigation/order_router.dart';
import 'package:shipment/navigation/shipment_router.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final _authRouter = AuthRouter();
  final _orderRouter = OrderRouter();
  final _incidentRouter = IncidentRouter();
  final _shipmentRouter = ShipmentRouter();

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(initial: true, page: SplashRoute.page),
    ..._authRouter.routes,
    ..._orderRouter.routes,
    ..._shipmentRouter.routes,
    ..._incidentRouter.routes,
    ScaffoldTabNavigationRouter.router,
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
