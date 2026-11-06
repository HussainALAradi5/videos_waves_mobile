import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/videos/comment/comment_messages_constants.dart';
import '../../../models/videos/comment/comment.dart';
import '../../../utilities/format/formatters.dart';
import '../../common/avatars/user_avatar.dart';
import 'owner_badge.dart';

/// A comment: avatar, name with the Owner badge, text, and the reply, approve, and ⋯ actions.
class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment, required this.actions, this.onReply, this.onApprove});

  final Comment comment;
  final Widget actions;
  final VoidCallback? onReply;
  final VoidCallback? onApprove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          onTap: () => context.push(AppRoutes.user(comment.author.userName)),
          child: UserAvatar(user: comment.author, size: 36),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
              Text(comment.author.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (comment.isVideoOwner) const OwnerBadge(),
              Text(formatRelative(comment.createdAt), style: muted),
              if (comment.isEdited) Text('· ${CommentMessages.edited}', style: muted),
            ]),
            const SizedBox(height: 2),
            Text(comment.content),
            if (comment.isPendingApproval)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.xs),
                child: Text(CommentMessages.restricted, style: muted?.copyWith(color: theme.colorScheme.tertiary)),
              ),
            Row(children: [
              if (onReply != null) TextButton(onPressed: onReply, child: const Text(CommentMessages.reply)),
              if (onApprove != null) TextButton(onPressed: onApprove, child: const Text(CommentMessages.approve)),
            ]),
          ]),
        ),
        actions,
      ]),
    );
  }
}
