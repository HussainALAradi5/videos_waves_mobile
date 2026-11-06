import 'package:flutter/material.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../models/videos/comment/comment.dart';
import '../../../utilities/format/formatters.dart';
import '../../common/avatars/user_avatar.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment, this.onDelete});

  final Comment comment;

  /// Null hides the delete action (only the author or an admin may delete).
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: UserAvatar(userName: comment.author.userName, imageUrl: comment.author.image),
      title: Text('${comment.author.userName} · ${formatRelative(comment.createdAt)}', style: Theme.of(context).textTheme.labelMedium),
      subtitle: Text(comment.content),
      trailing: onDelete == null
          ? null
          : IconButton(icon: const Icon(Icons.delete_outline), tooltip: AppMessages.delete, onPressed: onDelete),
    );
  }
}
