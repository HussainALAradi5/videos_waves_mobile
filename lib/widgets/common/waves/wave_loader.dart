import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../constants/common/gradients_constants.dart';

/// Bars rising and falling like a wave: the app loading indicator.
class WaveLoader extends StatefulWidget {
  const WaveLoader({super.key, this.size = 28});

  final double size;

  @override
  State<WaveLoader> createState() => _WaveLoaderState();
}

class _WaveLoaderState extends State<WaveLoader> with SingleTickerProviderStateMixin {
  static const int _bars = 5;
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) => Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
          for (var index = 0; index < _bars; index++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: widget.size / 7,
              height: widget.size * (0.35 + 0.65 * (0.5 + 0.5 * math.sin((_controller.value - index / _bars) * 2 * math.pi))),
              decoration: BoxDecoration(gradient: AppGradients.brand, borderRadius: BorderRadius.circular(4)),
            ),
        ]),
      ),
    );
  }
}
