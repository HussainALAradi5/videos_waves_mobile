import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../controllers/videos/comment/comment_list_controller.dart';
import '../../../controllers/videos/video/video_details_controller.dart';
import '../../../models/videos/comment/comment.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/dialogs/confirm_dialog.dart';
import '../../../widgets/common/feedback/error_view.dart';
import '../../../widgets/common/feedback/loading_view.dart';
import '../../../widgets/videos/comment/comment_composer.dart';
import '../../../widgets/videos/comment/comment_tile.dart';

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

  Future<void> _delete(BuildContext context, Comment comment) async {
    final comments = context.read<CommentListController>();
    final details = context.read<VideoDetailsController>();
    final isConfirmed = await ConfirmDialog.show(
      context,
      title: AppMessages.deleteCommentTitle,
      message: AppMessages.deleteCommentBody,
      confirmLabel: AppMessages.delete,
    );
    if (!isConfirmed || !context.mounted) return;
    await runWithFeedback(context, () async {
      await comments.remove(comment);
      details.adjustCommentsCount(-1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final comments = context.watch<CommentListController>();
    final user = auth.user;
    bool canDelete(Comment comment) => user != null && (user.isAdmin || user.id == comment.author.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${AppMessages.commentsTitle} (${comments.totalItems})', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: Spacing.sm),
        if (auth.isAuthenticated)
          CommentComposer(isPosting: comments.isPosting, onSubmit: (content) => _post(context, content))
        else
          const Text(AppMessages.signInToComment),
        const SizedBox(height: Spacing.sm),
        if (comments.isLoading && comments.items.isEmpty) const LoadingView(),
        if (comments.error != null && comments.items.isEmpty) ErrorView(error: comments.error!, onRetry: comments.loadFirstPage),
        if (comments.isEmpty) const Text(AppMessages.noComments),
        for (final comment in comments.items)
          CommentTile(comment: comment, onDelete: canDelete(comment) ? () => _delete(context, comment) : null),
        if (comments.hasMore)
          Center(
            child: TextButton(
              onPressed: comments.isLoadingMore ? null : comments.loadNextPage,
              child: const Text(AppMessages.loadMore),
            ),
          ),
      ],
    );
  }
}
