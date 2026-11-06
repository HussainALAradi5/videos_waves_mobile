import 'package:flutter/material.dart';

import '../../../constants/common/gradients_constants.dart';
import '../../../constants/common/motion_constants.dart';
import '../../../constants/common/radii_constants.dart';

/// Brand-gradient progress bar (0 to 1) that glides to each new value.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key, required this.value, this.height = 6});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.pill),
      child: Container(
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.centerLeft,
        child: AnimatedFractionallySizedBox(
          duration: Motion.smooth,
          widthFactor: value.clamp(0, 1),
          child: const DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.brand)),
        ),
      ),
    );
  }
}
