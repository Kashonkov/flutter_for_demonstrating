import 'package:flutter/material.dart';

class InkContainer extends StatefulWidget {
  final bool trigger;
  final Widget child;

  const InkContainer({super.key, required this.trigger, required this.child});

  @override
  State<InkContainer> createState() => _InkContainerState();
}

class _InkContainerState extends State<InkContainer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InkContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        painter: InkContainerPaint(
            _controller.value, Colors.grey),
        child: child,
      ),
      child: widget.child,
    );
  }
}

class InkContainerPaint extends CustomPainter {
  final double percent;
  final Paint _paint;
  final Color? color;

  InkContainerPaint(this.percent, this.color)
      : _paint = Paint()..color = color ?? const Color.fromRGBO(0, 0, 0, 0.3);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & Size(size.width, size.height));
    canvas.drawCircle(Offset(size.width / 2, 0), size.width * percent, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
