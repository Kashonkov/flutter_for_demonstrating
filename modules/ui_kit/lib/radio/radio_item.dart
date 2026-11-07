import 'package:common/exception/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/assets/ui_assets.dart';
import 'package:ui_kit/gap/gap.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/ui_icon/ui_icon.dart';

class RadioItem extends StatelessWidget {
  final bool value;
  final String title;
  final VoidCallback onTap;

  const RadioItem({super.key, required this.value, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          UiIcon(value ? UiIcons.checkedRadio : UiIcons.uncheckedRadio, size: UiIconSize.medium),
          Gap(8),
          Text(title, style: context.rfTextTheme().body2.copyWith(color: Color(0xFF1A1A1A)),),
        ],
      ),
    );
  }
}