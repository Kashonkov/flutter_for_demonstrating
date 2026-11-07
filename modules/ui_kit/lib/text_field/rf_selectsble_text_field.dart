import 'package:flutter/material.dart';
import 'package:ui_kit/gap/gap.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/ui_icon/ui_icon.dart';

class RfSelectableTextField extends StatelessWidget {
  final String? iconPath;
  final String text;
  final VoidCallback onTap;

  const RfSelectableTextField({super.key, this.iconPath, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFFB3B3B3)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(text, style: context.rfTextTheme().subtitle1,)),
            if (iconPath != null) ...[Gap(8), UiIcon(iconPath ?? "", size: UiIconSize.medium)],
          ],
        ),
      ),
    );
  }
}
