import 'package:flutter/material.dart';

class LoadingFrame extends StatelessWidget {
  const LoadingFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}