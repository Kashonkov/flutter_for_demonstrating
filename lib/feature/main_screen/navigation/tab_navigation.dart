import 'package:auto_route/auto_route.dart';
import 'package:incident/navigation/incident_router.gr.dart';
import 'package:lxe_app/feature/main_screen/bottom_navigation_const.dart';
import 'package:lxe_app/router/app_router.dart';
import 'package:profile/navigation/profile_router.gr.dart';
import 'package:shipment/navigation/shipment_router.gr.dart';

class ScaffoldTabNavigationRouter {
  static AutoRoute router = AutoRoute(
    page: MainRoute.page,
    path: '/',
    children: [
      AutoRoute(
        page: ShipmentNestedRoutingRoute.page,
        children: [
          AutoRoute(page: ShipmentListRoute.page),
          AutoRoute(page: ShipmentsMapRoute.page),],
      ),
      AutoRoute(
        page: IncidentNestedRoutingRoute.page,
        children: [
          AutoRoute(page: IncidentListRoute.page),
          AutoRoute(page: IncidentsMapRoute.page),],
      ),
      AutoRoute(page: ProfileRoute.page),
    ],
  );
}

const _routes = [
  // MainRouteNested(),
  // CatalogRoot(),
  // CartRouteNested(),
  // ProfileRouteNested(),
  ShipmentListRoute(),
  IncidentListRoute(),
  ProfileRoute(),
];

/// Класс отвечает за управление навигацией табов нижней панели навигации в проекте.
/// Инкапсулирует логику двойного нажатия на один таб (обрабатывается в [onTabPressed]).
/// Для корректной работы этой логики необходимо поддерживать актуалное состояние полей
/// [_prevIndex] и [_currentIndex]. Поэтому навигация по табам из проекта должна сопровождаться
/// вызовом метода [_updateCurrentIndex].
class TabNavigator {
  final StackRouter router;
  BottomNavigationIndex? _prevIndex;
  BottomNavigationIndex _currentIndex = BottomNavigationIndex.shipment;

  TabNavigator(this.router);

  List<PageRouteInfo> get tabNavigationRoutes => _routes;

  /// Метод нужен для кейсов, когда навигация между табами выполняется не нажатием пользователя
  /// на таб, а другими средствами. Например, переход из пустой корзины на таб каталога
  /// нажатием на кнопку экрана корзины.
  /// Метод выполняет навигацию и обновляет [_currentIndex] и [_prevIndex].
  void navigateToIndex(BottomNavigationIndex newIndex) {
    _updateCurrentIndex(newIndex);
    final targetRoute = _getRoute(_currentIndex);
    router.navigate(targetRoute);
  }

  /// Метод обрабатывает нажатия на таб навигации. Обновляет [_currentIndex] и [_prevIndex]
  /// и фиксирует кейсы двойного нажатия на таб.
  void onTabPressed(BottomNavigationIndex newIndex) {
    _updateCurrentIndex(newIndex);
    if (_currentIndex == _prevIndex) {
      final targetRoute = _getRoute(_currentIndex);
      // если _currentIndex == _prevIndex значит мы повторно тапаем по одному и тому же табу
      // для таба с [newIndex] производим замену всего стека на "главный для конкретного таба" экран
      router.replaceAll([targetRoute]);
    }
  }

  /// Обработка навигации "назад" для табов. Возвращает bool значение, сообщающее о том
  /// была ли обработана навигация или нет. Навигация не может быть обработана только в том случае
  /// если она вызывается с главного экрана. Этот кейс должен быть обработан в месте вызова.
  /// В ином случае выполняется навигация на главный роут.
  bool tabPop() {
    // if (_currentIndex != BottomNavigationIndex.main) {
    //   _updateCurrentIndex(BottomNavigationIndex.main);
    //   router.navigate(_routes[0]);
    //   return true;
    // } else {
    return false;
    // }
  }

  PageRouteInfo _getRoute(BottomNavigationIndex index) {
    return switch (index) {
      BottomNavigationIndex.shipment => const ShipmentListRoute(),
      BottomNavigationIndex.incident => const IncidentListRoute(),
      BottomNavigationIndex.profile => const ProfileRoute(),
    };
  }

  void _updateCurrentIndex(BottomNavigationIndex newIndex) {
    _prevIndex = _currentIndex;
    _currentIndex = newIndex;
  }
}
