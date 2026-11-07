import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/users/settings/settings_controller.dart';
import '../../../controllers/videos/video/video_details_controller.dart';
import '../../../utilities/errors/api_exception.dart';
import '../../../widgets/common/feedback/empty_view.dart';
import '../../../widgets/common/feedback/error_view.dart';
import '../../../widgets/common/feedback/loading_view.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import '../../../widgets/videos/video/video_player_view.dart';
import '../../../widgets/videos/video/video_stats_row.dart';
import 'video_comments_section.dart';
import 'video_owner_row.dart';

class VideoDetailsBody extends StatelessWidget {
  const VideoDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<VideoDetailsController>();
    final video = details.video;
    final theme = Theme.of(context);

    Widget body;
    if (details.isLoading && video == null) {
      body = const LoadingView();
    } else if (details.error is ApiException && (details.error! as ApiException).isNotFound) {
      body = const EmptyView(title: AppMessages.videoNotFound, icon: Icons.videocam_off);
    } else if (details.error != null || video == null) {
      body = ErrorView(error: details.error ?? AppMessages.unexpectedError, onRetry: details.load);
    } else {
      body = ListView(
        padding: const EdgeInsets.only(bottom: Spacing.xl),
        children: [
          Hero(tag: 'video-${video.id}', child: VideoPlayerView(
              url: video.videoUrl,
              onFirstPlay: details.recordViewOnce,
              autoplay: context.select<SettingsController, bool>((settings) => settings.settings?.autoplayVideos ?? true),
            )),
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(video.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: Spacing.sm),
              VideoStatsRow(video: video),
              const SizedBox(height: Spacing.md),
              VideoOwnerRow(video: video),
              if (video.description.isNotEmpty) ...[
                const SizedBox(height: Spacing.md),
                Text(video.description, style: theme.textTheme.bodyMedium),
              ],
              const Divider(height: Spacing.xl),
              const VideoCommentsSection(),
            ]),
          ),
        ],
      );
    }
    // Opened directly (deep link or after sign-in) there is nothing to pop, so offer the feed instead.
    final leading = context.canPop()
        ? null
        : IconButton(icon: const Icon(Icons.home_outlined), tooltip: AppMessages.navFeed, onPressed: () => context.go(AppRoutes.feed));
    return Scaffold(appBar: AppBar(leading: leading), body: ConstrainedContent(child: body));
  }
}
