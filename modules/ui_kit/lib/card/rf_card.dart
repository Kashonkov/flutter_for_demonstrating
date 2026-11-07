import 'package:flutter/material.dart';

class RfCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const RfCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: padding ?? EdgeInsets.all(16),
      child: child,
    );
  }
}
