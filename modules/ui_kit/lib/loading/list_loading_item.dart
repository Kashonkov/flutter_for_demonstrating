import 'package:flutter/material.dart';
import 'package:ui_kit/card/rf_card.dart';

class ListLoadingItem extends StatelessWidget {
  const ListLoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RfCard(
        child: Align(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              constraints: BoxConstraints(maxWidth: 24, maxHeight: 24),
            ),
          ),
        ),
      ),
    );
  }
}
