import 'package:auto_route/auto_route.dart';
import 'package:incident/navigation/incident_router.gr.dart';

const modules = <Type>[];

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route', generateForDir: ["modules/incident/lib"])
class IncidentRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [AutoRoute(page: IncidentDetailsRoute.page)];

  @override
  List<AutoRouteGuard> get guards => [];
}
