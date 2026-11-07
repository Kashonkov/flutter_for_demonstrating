import 'dart:ui';

import 'package:flutter/material.dart';

class MapZoomButtons extends StatelessWidget {
  final VoidCallback onZoomInTap;
  final VoidCallback onZoomOutTap;

  const MapZoomButtons({super.key, required this.onZoomInTap, required this.onZoomOutTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 104,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black.withAlpha(127)),
            shape: BoxShape.circle,
          ),
          child: IconButton(onPressed: onZoomInTap, icon: Icon(Icons.add)),
        ),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black.withAlpha(127)),
            shape: BoxShape.circle,
          ),
          child: IconButton(onPressed: onZoomOutTap, icon: Icon(Icons.remove)),
        ),
      ],
    ),
  );
}
