import 'package:auto_route/auto_route.dart';

const modules = <Type>[];

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route', generateForDir: ["modules/profile/lib"])
class ProfileRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [];

  @override
  List<AutoRouteGuard> get guards => [];
}
