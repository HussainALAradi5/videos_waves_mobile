import 'package:flutter/material.dart';

import '../../../constants/common/ui_constants.dart';
import '../../../models/videos/video/video.dart';
import '../../../utilities/format/formatters.dart';

class VideoStatsRow extends StatelessWidget {
  const VideoStatsRow({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Stat(icon: Icons.favorite_border, value: video.likesCount, style: style),
        _Stat(icon: Icons.chat_bubble_outline, value: video.commentsCount, style: style),
        _Stat(icon: Icons.visibility_outlined, value: video.viewsCount, style: style),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, this.style});

  final IconData icon;
  final int value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Spacing.md),
      child: Row(children: [Icon(icon, size: Spacing.md), const SizedBox(width: Spacing.xs), Text(formatCount(value), style: style)]),
    );
  }
}
