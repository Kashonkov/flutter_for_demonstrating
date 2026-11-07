import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/tab/rf_tab.dart';

typedef OnValueChanged<T> = Function<T>(T value);

class RfTabBar<T extends Object> extends StatelessWidget {
  const RfTabBar({
    super.key,
    required this.tabs,
    required this.onValueChanged,
    this.value,
    this.proportionalWidth = false,
  });

  final List<RfTab<T>> tabs;
  final ValueChanged<T> onValueChanged;
  final bool proportionalWidth;
  final T? value;

  @override
  Widget build(BuildContext context) => CupertinoSlidingSegmentedControl<T>(
        children: {
          for (var element in tabs)
            element.value: Text(
              element.title,
              textAlign: TextAlign.center,
              // style: context.theme.typography.capTitle12,
            )
        },
        proportionalWidth: proportionalWidth,
        backgroundColor: Colors.grey,
        groupValue: value,
        onValueChanged: (value) {
          if (value != null) {
            onValueChanged(value);
          }
        },
      );
}
