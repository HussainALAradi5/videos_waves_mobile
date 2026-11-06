import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Three dots bouncing in turn inside a bubble.
class TypingDots extends StatefulWidget {
  const TypingDots({super.key});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(left: 40, top: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(18)),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) => Row(mainAxisSize: MainAxisSize.min, children: [
          for (var index = 0; index < 3; index++)
            Transform.translate(
              offset: Offset(0, -3 * math.max(0, math.sin((_controller.value - index * 0.2) * 2 * math.pi))),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: scheme.onSurfaceVariant, shape: BoxShape.circle),
              ),
            ),
        ]),
      ),
    );
  }
}
