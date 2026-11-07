import 'package:flutter/material.dart';

class CustomClampingScrollPhysics extends ClampingScrollPhysics {
  const CustomClampingScrollPhysics({
    super.parent,
    this.canUnderScroll = false,
    this.canOverScroll = false,
  });

  final bool canUnderScroll;

  final bool canOverScroll;

  @override
  CustomClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomClampingScrollPhysics(
        parent: buildParent(ancestor),
        canUnderScroll: canUnderScroll,
        canOverScroll: canOverScroll);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels && position.pixels <= position.minScrollExtent) {
      // underscroll
      return canUnderScroll ? 0.0 : value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels && position.pixels < value) {
      // overscroll
      return canOverScroll ? 0.0 : value - position.pixels;
    }
    if (value < position.minScrollExtent && position.minScrollExtent < position.pixels) {
      // hit top edge
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent && position.maxScrollExtent < value) {
      // hit bottom edge
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}
