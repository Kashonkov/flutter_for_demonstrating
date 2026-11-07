import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/index.dart';

class RfBackButton extends StatelessWidget {
  const RfBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: AutoRouter.of(context).pop,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Colors.black.withAlpha(127)),
        ),
        child: UiIcon(UiIcons.chevronLeft, size: UiIconSize.xsmall, fit: BoxFit.none,)
      ),
    );
  }
}
