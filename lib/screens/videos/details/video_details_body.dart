import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../controllers/videos/video/video_details_controller.dart';
import '../../../utilities/errors/api_exception.dart';
import '../../../utilities/format/formatters.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/avatars/user_avatar.dart';
import '../../../widgets/common/feedback/empty_view.dart';
import '../../../widgets/common/feedback/error_view.dart';
import '../../../widgets/common/feedback/loading_view.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import '../../../widgets/videos/video/like_button.dart';
import '../../../widgets/videos/video/video_player_view.dart';
import '../../../widgets/videos/video/video_stats_row.dart';
import 'video_comments_section.dart';

class VideoDetailsBody extends StatelessWidget {
  const VideoDetailsBody({super.key});

  void _onLike(BuildContext context, VideoDetailsController details) {
    final auth = context.read<AuthController>();
    if (!auth.isAuthenticated) {
      context.push('${AppRoutes.login}?${AppRoutes.redirectParam}=${Uri.encodeComponent(AppRoutes.video(details.videoId))}');
      return;
    }
    runWithFeedback(context, details.toggleLike);
  }

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
          VideoPlayerView(url: video.videoUrl, onFirstPlay: details.recordViewOnce),
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(video.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    UserAvatar(userName: video.owner.userName, imageUrl: video.owner.image),
                    const SizedBox(width: Spacing.sm),
                    Expanded(child: Text('${video.owner.userName} · ${formatRelative(video.createdAt)}')),
                    LikeButton(video: video, isBusy: details.isLiking, onPressed: () => _onLike(context, details)),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                VideoStatsRow(video: video),
                if (video.description.isNotEmpty) ...[
                  const SizedBox(height: Spacing.md),
                  Text(video.description, style: theme.textTheme.bodyMedium),
                ],
                const Divider(height: Spacing.xl),
                const VideoCommentsSection(),
              ],
            ),
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
