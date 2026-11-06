import 'dart:math' as math;

import 'package:flutter/material.dart';

/// One sine wave strip; `phase` (0..1) moves it sideways so it drifts when animated.
class WavePainter extends CustomPainter {
  const WavePainter({required this.phase, required this.color, required this.amplitude, this.baseline});

  final double phase;
  final Color color;
  final double amplitude;

  /// Height of the still-water line from the top; the middle when null.
  final double? baseline;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(0, size.height);
    for (double x = 0; x <= size.width; x += 4) {
      final y = (baseline ?? size.height / 2) + math.sin((x / size.width * 2 * math.pi) + phase * 2 * math.pi) * amplitude;
      path.lineTo(x, y);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => oldDelegate.phase != phase || oldDelegate.color != color;
}
