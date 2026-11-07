import 'package:auto_route/auto_route.dart';
import 'package:shipment/navigation/shipment_router.gr.dart';

const modules = <Type>[];

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route', generateForDir: ["modules/shipment/lib"])
class ShipmentRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [AutoRoute(page: ShipmentDetailsRoute.page),];

  @override
  List<AutoRouteGuard> get guards => [];
}
