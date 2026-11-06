import 'package:flutter/material.dart';

import '../../../constants/common/motion_constants.dart';
import '../../../utilities/format/formatters.dart';

/// A number that counts up to its new value, with a label under it.
class ProfileCount extends StatelessWidget {
  const ProfileCount({super.key, required this.value, required this.label, this.onTap});

  final int value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(children: [
          TweenAnimationBuilder<double>(
            tween: Tween(end: value.toDouble()),
            duration: Motion.smooth,
            builder: (context, shown, _) => Text(formatCount(shown.round()), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    );
  }
}
