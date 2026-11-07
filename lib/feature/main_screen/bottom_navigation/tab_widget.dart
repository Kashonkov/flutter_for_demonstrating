import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lxe_app/feature/main_screen/bottom_navigation/tab_widget_content.dart';
import 'package:lxe_app/feature/main_screen/bottom_navigation_const.dart';
import 'package:lxe_app/l10n/app_localizations.dart';
import 'package:lxe_app/l10n/localization_extension.dart';
import 'package:ui_kit/index.dart';

// todo вынести в uikit
const _barNavigationTabHeight = 64.0;

/// Формирующий виджет таба (bottom navigation)
class TabWidget extends StatelessWidget {
  const TabWidget({
    super.key,
    required this.index,
    required this.onTap,
    required this.activeIndex,
    required this.tabCount,
  });

  final BottomNavigationIndex index;
  final BottomNavigationIndex activeIndex;
  final Function(BottomNavigationIndex index) onTap;
  final int tabCount;

  String _getTabName(BottomNavigationIndex currentIndex, AppLocalizations localization) {
    switch (currentIndex) {
      case BottomNavigationIndex.shipment:
        return localization.shipments;
      case BottomNavigationIndex.incident:
        return localization.incidents;
      case BottomNavigationIndex.profile:
        return localization.profile;
    }
  }

  IconData _getNotActiveIconPath(BottomNavigationIndex currentIndex) {
    switch (currentIndex) {
      case BottomNavigationIndex.shipment:
        return Icons.local_shipping_outlined;
      case BottomNavigationIndex.incident:
        return Icons.warning_amber_outlined;
      case BottomNavigationIndex.profile:
        return Icons.person_outlined;
    }
  }

  IconData _getActiveIconPath(BottomNavigationIndex currentIndex) {
    switch (currentIndex) {
      case BottomNavigationIndex.shipment:
        return Icons.local_shipping;
      case BottomNavigationIndex.incident:
        return Icons.warning;
      case BottomNavigationIndex.profile:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabWidth = MediaQuery.of(context).size.width / tabCount;
    final localization = context.loc;
    final tabName = _getTabName(index, localization);
    final iconPath = _getNotActiveIconPath(index);
    final activeIconPath = _getActiveIconPath(index);
    final isActive = index == activeIndex;

    return InkWell(
      onTap: () => onTap(index),
      child: TabWidgetContent(
        tabName: tabName,
        iconPath: iconPath,
        activeIconPath: activeIconPath,
        isActive: isActive,
        width: tabWidth,
        height: _barNavigationTabHeight,
      ),
    );
  }
}
