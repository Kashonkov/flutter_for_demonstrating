import 'package:auto_route/auto_route.dart';
import 'package:order/navigation/order_router.gr.dart';

const modules = <Type>[];

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route', generateForDir: ["modules/order/lib"])
class OrderRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get  routes => [AutoRoute(page: OrderListRoute.page)];

  @override
  List<AutoRouteGuard> get guards => [];
}
