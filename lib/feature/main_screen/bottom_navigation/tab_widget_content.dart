import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/ui_icon/ui_icon.dart';

class TabWidgetContent extends StatelessWidget {
  final String tabName;
  final IconData activeIconPath;
  final IconData iconPath;
  final bool isActive;
  final double width;
  final double height;
  final Color? contentColor;

  const TabWidgetContent({
    super.key,
    required this.tabName,
    required this.activeIconPath,
    required this.iconPath,
    required this.isActive,
    this.width = 44.0,
    this.height = 38.0,
    this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    // final colors = context.theme.extension<UiColors>();
    // final textTheme = context.theme.extension<TextThemeExtension>();
    final color = contentColor ?? (isActive ? Color(0xFF1A1A1A) : Color(0x991A1A1A));

    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 24,
            alignment: Alignment.center,
            child: Icon(isActive ? activeIconPath : iconPath, size: 24, color: color),
          ),
          Text(tabName, style: context.rfTextTheme().caption.copyWith(color: color)),
        ],
      ),
    );
  }
}
