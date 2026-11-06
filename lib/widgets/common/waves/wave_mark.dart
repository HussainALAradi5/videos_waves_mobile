import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../constants/common/gradients_constants.dart';
import '../../../constants/common/motion_constants.dart';
import 'wave_painter.dart';

/// The app icon: three layers of sea rolling at different speeds and swelling up and down.
class WaveMark extends StatefulWidget {
  const WaveMark({super.key, this.size = 32});

  final double size;

  @override
  State<WaveMark> createState() => _WaveMarkState();
}

class _WaveMarkState extends State<WaveMark> with SingleTickerProviderStateMixin {
  // (opacity, crest height as a share of the tile, amplitude share, whole cycles per loop).
  // Whole-number speeds keep the loop seamless when the controller wraps.
  static const List<(double, double, double, int)> _layers = [(0.35, 0.28, 0.10, -1), (0.6, 0.42, 0.09, 1), (0.95, 0.56, 0.07, 2)];

  late final AnimationController _controller = AnimationController(vsync: this, duration: Motion.waveMark);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MediaQuery.disableAnimationsOf(context) ? _controller.stop() : _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.brand),
        child: SizedBox.square(
          dimension: size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, _) {
              final swell = math.sin(_controller.value * 2 * math.pi) * size * 0.04;
              return Stack(children: [
                for (var index = 0; index < _layers.length; index++)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    // Front layers swell more, like water nearer the shore.
                    top: size * (_layers[index].$2 - _layers[index].$3) + swell * (index + 1) * 0.6,
                    child: CustomPaint(
                      painter: WavePainter(
                        phase: _controller.value * _layers[index].$4,
                        color: Colors.white.withValues(alpha: _layers[index].$1),
                        amplitude: size * _layers[index].$3,
                        baseline: size * _layers[index].$3,
                      ),
                    ),
                  ),
              ]);
            },
          ),
        ),
      ),
    );
  }
}
