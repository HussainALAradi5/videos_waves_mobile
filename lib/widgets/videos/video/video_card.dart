import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../models/videos/video/video.dart';
import '../../../utilities/format/formatters.dart';
import '../../../utilities/format/media_format_utility.dart';
import '../../common/avatars/user_avatar.dart';
import 'video_preview.dart';
import 'video_stats_row.dart';

/// Feed card: a still of the video (CDN thumbnail or first frame) with its duration, then the owner row.
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AspectRatio(
            aspectRatio: Layout.videoAspectRatio,
            child: Stack(fit: StackFit.expand, children: [
              Hero(
                tag: 'video-${video.id}',
                child: VideoPreview(videoUrl: video.videoUrl, thumbnailUrl: video.thumbnailUrl),
              ),
              const Center(child: Icon(Icons.play_circle_fill, size: 56, color: AppColors.onVideoMuted)),
              if (video.durationSeconds != null)
                Positioned(
                  right: Spacing.sm,
                  bottom: Spacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(Radii.md)),
                    child: Text(formatDuration(video.durationSeconds), style: const TextStyle(color: AppColors.onVideo, fontSize: 12)),
                  ),
                ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Row(children: [
              GestureDetector(
                onTap: () => context.push(AppRoutes.user(video.owner.userName)),
                child: UserAvatar(user: video.owner, size: 40),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(video.title, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${video.owner.userName} · ${formatRelative(video.createdAt)}', style: theme.textTheme.bodySmall),
                ]),
              ),
              VideoStatsRow(video: video),
            ]),
          ),
        ]),
      ),
    );
  }
}
