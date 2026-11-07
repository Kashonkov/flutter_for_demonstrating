import 'dart:ui';

import 'package:flutter/material.dart';

class DraggableModalContainer extends StatelessWidget {
  /// контейнер для всех модалок с градиентом в тёмной теме
  const DraggableModalContainer({
    super.key,
    required this.child,
    this.stickyChild,
    required this.controller,
    required this.onDrag,
  });

  final Widget child;

  final Widget? stickyChild;

  final ValueChanged<double> onDrag;

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).extension<UiColors>();

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            offset: Offset.zero,
            blurRadius: 14,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          children: <Widget>[
            _GrabHandle(onDrag: onDrag, child: stickyChild),
            Expanded(
              child: SingleChildScrollView(controller: controller, child: child),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrabHandle extends StatelessWidget {
  final ValueChanged<double> onDrag;
  final Widget? child;

  const _GrabHandle({required this.onDrag, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (d) => onDrag(d.delta.dy),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(top: 8,),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey,
                  ),
                  child: const SizedBox(width: 24, height: 4),
                ),
              ),
            ),
          ),
          if (child != null) child ?? SizedBox.shrink(),
        ],
      ),
    );
  }
}
