import 'package:flutter/material.dart';

import '../../../constants/common/ui_constants.dart';
import '../../../models/videos/video/video.dart';
import '../../../utilities/format/formatters.dart';
import '../../common/avatars/user_avatar.dart';
import 'video_stats_row.dart';

/// Feed card. Uses a lightweight cover instead of a player so long lists stay smooth.
class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video, required this.onTap});

  final Video video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: Spacing.md),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: Layout.videoAspectRatio,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.tertiary]),
                ),
                child: Icon(Icons.play_circle_fill, size: Spacing.xl * 2, color: theme.colorScheme.onPrimary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: Spacing.sm),
                  Row(
                    children: [
                      UserAvatar(userName: video.owner.userName, imageUrl: video.owner.image),
                      const SizedBox(width: Spacing.sm),
                      Expanded(child: Text('${video.owner.userName} · ${formatRelative(video.createdAt)}', style: theme.textTheme.bodySmall)),
                      VideoStatsRow(video: video),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
