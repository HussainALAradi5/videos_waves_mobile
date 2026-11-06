import 'package:flutter/material.dart';

import '../../../constants/common/radii_constants.dart';
import '../../../constants/common/spacing_constants.dart';

/// Placeholder rows that pulse while a list loads.
class SkeletonList extends StatefulWidget {
  const SkeletonList({super.key, this.rows = 5});

  final int rows;

  @override
  State<SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<SkeletonList> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    Widget bar(double width) => Container(height: 10, width: width, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(Radii.pill)));
    return FadeTransition(
      opacity: Tween(begin: 0.4, end: 1.0).animate(_controller),
      child: Column(children: [
        for (var index = 0; index < widget.rows; index++)
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Row(children: [
              CircleAvatar(backgroundColor: color),
              const SizedBox(width: Spacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [bar(120), const SizedBox(height: 8), bar(200)])),
            ]),
          ),
      ]),
    );
  }
}
