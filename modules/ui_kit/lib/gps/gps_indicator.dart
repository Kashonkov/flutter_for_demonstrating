import 'package:flutter/material.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';
import 'package:ui_kit/gap/gap.dart';
import 'package:ui_kit/l10n/localization_extension.dart';

class GpsIndicator extends StatelessWidget {
  const GpsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF000000)),
    );
  }
}

class InactiveGpsIndicator extends StatelessWidget {
  const InactiveGpsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0x33000000)),
    );
  }
}
