import 'package:flutter/material.dart';

import '../../constants/users/settings/bubble_gradients_constants.dart';
import '../../enums/users/settings/bubble_color.dart';
import '../../enums/users/settings/bubble_style.dart';

/// Corner radius for the big and the "tail" corner of each shape.
({double big, double tail}) bubbleRadii(BubbleStyle style) => switch (style) {
      BubbleStyle.rounded => (big: 18, tail: 4),
      BubbleStyle.square => (big: 8, tail: 2),
      BubbleStyle.minimal => (big: 12, tail: 12),
    };

/// The decoration and text colour of one bubble from the reader's chat settings (same rules as the web app).
({BoxDecoration decoration, Color foreground}) bubbleLook({
  required ColorScheme scheme,
  required bool isMine,
  required bool isUnsent,
  required BubbleStyle style,
  required BubbleColor myColor,
  required BubbleColor othersColor,
}) {
  final radii = bubbleRadii(style);
  final radius = BorderRadius.only(
    topLeft: Radius.circular(radii.big),
    topRight: Radius.circular(radii.big),
    bottomLeft: Radius.circular(isMine ? radii.big : radii.tail),
    bottomRight: Radius.circular(isMine ? radii.tail : radii.big),
  );
  if (isUnsent) return (decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: radius), foreground: scheme.onSurfaceVariant);
  if (style == BubbleStyle.minimal) {
    return (
      decoration: BoxDecoration(
        color: isMine ? scheme.primary.withValues(alpha: 0.10) : Colors.transparent,
        borderRadius: radius,
        border: Border.all(color: isMine ? scheme.primary.withValues(alpha: 0.45) : scheme.outlineVariant),
      ),
      foreground: scheme.onSurface,
    );
  }
  final color = isMine ? myColor : othersColor;
  if (color == BubbleColor.neutral) return (decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: radius), foreground: scheme.onSurface);
  return (decoration: BoxDecoration(gradient: BubbleGradients.of(color), borderRadius: radius), foreground: Colors.white);
}
