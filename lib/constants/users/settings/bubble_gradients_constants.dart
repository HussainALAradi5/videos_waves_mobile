import 'package:flutter/material.dart';

import '../../../enums/users/settings/bubble_color.dart';

/// Background of your own chat bubbles per colour setting (same as the web app).
class BubbleGradients {
  const BubbleGradients._();

  static const Map<BubbleColor, List<Color>> colors = {
    BubbleColor.wave: [Color(0xFF3A7BB5), Color(0xFF1F4E79)],
    BubbleColor.ocean: [Color(0xFF0A9DF0), Color(0xFF0F64A8)],
    BubbleColor.sunset: [Color(0xFFFF7A9C), Color(0xFFFF9F43)],
    BubbleColor.forest: [Color(0xFF1FB88A), Color(0xFF0F7A5C)],
    BubbleColor.mono: [Color(0xFF3F4656), Color(0xFF1F2430)],
  };

  static LinearGradient of(BubbleColor color) => LinearGradient(colors: colors[color]!);
}
