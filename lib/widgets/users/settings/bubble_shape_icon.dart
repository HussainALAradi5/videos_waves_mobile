import 'package:flutter/material.dart';

import '../../../enums/users/settings/bubble_style.dart';

/// Two tiny bubbles (theirs grey, yours blue) in the given shape, so each choice shows what it looks like.
class BubbleShapeIcon extends StatelessWidget {
  const BubbleShapeIcon({super.key, required this.shape});

  final BubbleStyle shape;

  static const Size _size = Size(16, 12);

  ({double big, double tail}) get _radii => switch (shape) {
        BubbleStyle.rounded => (big: 7, tail: 2),
        BubbleStyle.square => (big: 3, tail: 1),
        BubbleStyle.minimal => (big: 4, tail: 4),
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isMinimal = shape == BubbleStyle.minimal;
    final radii = _radii;
    BorderRadius corners({required bool isMine}) => BorderRadius.only(
          topLeft: Radius.circular(radii.big),
          topRight: Radius.circular(radii.big),
          bottomLeft: Radius.circular(isMine ? radii.big : radii.tail),
          bottomRight: Radius.circular(isMine ? radii.tail : radii.big),
        );
    Widget bubble({required bool isMine}) => Container(
          width: _size.width,
          height: _size.height,
          decoration: BoxDecoration(
            color: isMinimal ? (isMine ? scheme.primary.withValues(alpha: 0.12) : Colors.transparent) : (isMine ? scheme.primary : scheme.surfaceContainerHighest),
            borderRadius: corners(isMine: isMine),
            border: isMinimal ? Border.all(color: isMine ? scheme.primary : scheme.outline, width: 1.5) : null,
          ),
        );
    return ExcludeSemantics(
      child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
        bubble(isMine: false),
        const SizedBox(width: 3),
        Padding(padding: const EdgeInsets.only(bottom: 4), child: bubble(isMine: true)),
      ]),
    );
  }
}
