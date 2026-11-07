import 'package:auto_route/auto_route.dart';
import 'package:auth/navigation/auth_router.gr.dart';

const modules = <Type>[];

@AutoRouterConfig(
    replaceInRouteName: 'Screen|Page,Route', generateForDir: ["modules/auth/lib"])
class AuthRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page),
      ];

  @override
  List<AutoRouteGuard> get guards => [
      ];
}
