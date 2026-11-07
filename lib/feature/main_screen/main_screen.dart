import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:lxe_app/feature/main_screen/bottom_navigation/navigation_bar.dart';
import 'package:lxe_app/feature/main_screen/bottom_navigation_const.dart';
import 'package:lxe_app/feature/main_screen/navigation/tab_navigation.dart';

class MainScreenContent extends StatelessWidget {
  final TabNavigator navigator;

  const MainScreenContent({super.key, required this.navigator});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      animationDuration: Duration.zero,
      routes: navigator.tabNavigationRoutes,
      inheritNavigatorObservers: true,
      bottomNavigationBuilder: (_, tabsRouter) {
        return AppNavigationBar(
          activeIndex: BottomNavigationIndex.values[tabsRouter.activeIndex],
          onTap: (BottomNavigationIndex index) {
            tabsRouter.setActiveIndex(index.index);
            navigator.onTabPressed(index);
          },
        );
      },
    );
  }
}
