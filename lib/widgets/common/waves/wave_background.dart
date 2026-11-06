import 'package:flutter/material.dart';

import '../../../constants/common/app_colors_constants.dart';
import '../../../constants/common/motion_constants.dart';
import 'wave_painter.dart';

/// Layered waves drifting along the bottom of the screen: the brand backdrop.
class WaveBackground extends StatefulWidget {
  const WaveBackground({super.key});

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: Motion.wave);

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
    const layers = [(AppColors.brandStart, 0.10, 14.0, 1.0), (AppColors.brandMiddle, 0.08, 10.0, -0.6), (AppColors.brandEnd, 0.06, 8.0, 0.4)];
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 120,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, _) => Stack(children: [
              for (final (color, opacity, amplitude, speed) in layers)
                Positioned.fill(
                  child: CustomPaint(
                    painter: WavePainter(phase: _controller.value * speed, color: color.withValues(alpha: opacity), amplitude: amplitude),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}
