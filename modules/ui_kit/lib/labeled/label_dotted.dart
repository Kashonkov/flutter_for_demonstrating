import 'package:flutter/material.dart';
import 'package:ui_kit/index.dart';

class LabeledValue extends StatelessWidget {
  final String label;
  final String value;

  const LabeledValue({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.rfTextTheme().body2Variant.copyWith(color: Color(0x80000000))),
        Text(value, style: context.rfTextTheme().body2Variant),
      ],
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;

  _DottedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashGap,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = 0;
    final y = size.height / 2;

    while (x < size.width) {
      final double x2 = (x + dashWidth).clamp(0, size.width);
      canvas.drawLine(Offset(x, y), Offset(x2, y), paint);
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter old) =>
      old.color != color ||
      old.dashWidth != dashWidth ||
      old.dashWidth != dashWidth ||
      old.dashGap != dashGap ||
      old.strokeWidth != strokeWidth;
}
