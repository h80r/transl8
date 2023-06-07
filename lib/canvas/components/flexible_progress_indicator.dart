import 'package:flutter/material.dart';

class FlexibleProgressIndicator extends StatelessWidget {
  final int flex;
  const FlexibleProgressIndicator({super.key, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
