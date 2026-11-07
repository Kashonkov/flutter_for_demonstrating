import 'package:flutter/material.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/l10n/localization_extension.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTuneClicked;
  final bool showTunes;
  final double verticalSize;
  final Color? borderColor;

  const SearchWidget({
    super.key,
    required this.controller,
    this.onTuneClicked,
    this.showTunes = true,
    this.verticalSize = 36,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RfTextField(
            controller: controller,
            hint: context.commonLoc.search,
            verticalPadding: (verticalSize - 24) / 2,
            prefix: UiIcon(UiIcons.search),
            borderColor: borderColor,
          ),
        ),
        if (showTunes) ...[
          Gap(12),
          GestureDetector(
            onTap: onTuneClicked,
            child: Container(
              height: verticalSize,
              width: verticalSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border:  borderColor != null ? Border.all(width: 1, color: borderColor?? Colors.transparent): null,
              ),
              padding: EdgeInsets.all(8),
              child: UiIcon(UiIcons.tune, size: UiIconSize.medium, fit: BoxFit.none),
            ),
          ),
        ],
      ],
    );
  }
}
