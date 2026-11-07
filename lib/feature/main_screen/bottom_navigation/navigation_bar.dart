import 'package:flutter/material.dart';
import 'package:lxe_app/feature/main_screen/bottom_navigation/tab_widget.dart';
import 'package:lxe_app/feature/main_screen/bottom_navigation_const.dart';

const bottomNavigationBarHeight = 64.0;

class AppNavigationBar extends StatelessWidget {
  final BottomNavigationIndex activeIndex;
  final Function(BottomNavigationIndex index) onTap;

  const AppNavigationBar({super.key, required this.activeIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // final colors = context.theme.extension<UiColors>().checkColorsTheme();
    final bottomInsets = MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    final children = BottomNavigationIndex.values
        .map<Widget>(
          (value) => TabWidget(
            tabCount: BottomNavigationIndex.values.length + 1,
            index: value,
            activeIndex: activeIndex,
            onTap: onTap,
          ),
        )
        .toList();

    return Material(
      elevation: 8,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: bottomNavigationBarHeight + bottomInsets,
        padding: EdgeInsets.only(bottom: bottomInsets + 8),
        decoration: BoxDecoration(color: Colors.white, border: BoxBorder.fromLTRB(top: BorderSide(color: Color(0x4D000000)))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: children),
      ),
    );
  }
}
