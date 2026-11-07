import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../controllers/videos/comment/comment_list_controller.dart';
import '../../../controllers/videos/video/video_details_controller.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/feedback/error_view.dart';
import '../../../widgets/common/feedback/skeleton_list.dart';
import '../../../widgets/common/motion/fade_slide_in.dart';
import '../../../widgets/videos/comment/comment_composer.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../widgets/videos/comment/comments_locked.dart';
import 'comment_thread.dart';

class VideoCommentsSection extends StatelessWidget {
  const VideoCommentsSection({super.key});

  Future<bool> _post(BuildContext context, String content) {
    final comments = context.read<CommentListController>();
    final details = context.read<VideoDetailsController>();
    return runWithFeedback(context, () async {
      await comments.add(content);
      details.adjustCommentsCount(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSignedIn = context.select<AuthController, bool>((auth) => auth.isAuthenticated);
    if (!isSignedIn) {
      final videoId = context.select<VideoDetailsController, String?>((details) => details.video?.id);
      return CommentsLocked(returnTo: videoId == null ? AppRoutes.feed : AppRoutes.video(videoId));
    }
    final comments = context.watch<CommentListController>();
    final items = comments.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The video's count includes replies, so it matches the feed card.
        Text('${AppMessages.commentsTitle} (${context.select<VideoDetailsController, int>((details) => details.video?.commentsCount ?? 0)})',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: Spacing.sm),
        CommentComposer(isPosting: comments.isPosting, onSubmit: (content) => _post(context, content)),
        const SizedBox(height: Spacing.sm),
        if (comments.isLoading && items.isEmpty) const SkeletonList(rows: 3),
        if (comments.error != null && items.isEmpty) ErrorView(error: comments.error!, onRetry: comments.loadFirstPage),
        if (comments.isEmpty) const Text(AppMessages.noComments),
        for (var index = 0; index < items.length; index++)
          FadeSlideIn(key: ValueKey(items[index].id), index: index, child: CommentThread(comment: items[index], list: comments)),
        if (comments.hasMore)
          Center(
            child: TextButton(onPressed: comments.isLoadingMore ? null : comments.loadNextPage, child: const Text(AppMessages.loadMore)),
          ),
      ],
    );
  }
}
