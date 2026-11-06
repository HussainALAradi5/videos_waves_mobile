import 'package:flutter/material.dart';

import '../../../constants/common/motion_constants.dart';

/// Fades and rises its child in once, optionally after a stagger delay (list rows, cards).
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Motion.smooth + Motion.stagger * index.clamp(0, 10),
      curve: Curves.easeOutCubic,
      builder: (context, progress, child) => Opacity(
        opacity: progress,
        child: Transform.translate(offset: Offset(0, (1 - progress) * Motion.slideOffset), child: child),
      ),
      child: child,
    );
  }
}
