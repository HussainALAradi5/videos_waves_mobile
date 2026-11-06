import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/limits_constants.dart';
import '../../../constants/videos/comment/comment_messages_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../controllers/videos/comment/comment_list_controller.dart';
import '../../../controllers/videos/video/video_details_controller.dart';
import '../../../models/common/ui/action_item.dart';
import '../../../models/videos/comment/comment.dart';
import '../../../utilities/errors/api_exception.dart';
import '../../../enums/common/toast_type.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../utilities/ui/undo_snackbar_utility.dart';
import '../../../widgets/common/forms/inline_editor.dart';
import '../../../widgets/common/menus/action_sheet_button.dart';
import '../../../widgets/videos/comment/comment_tile.dart';

/// One comment or reply with its actions: reply, inline edit, delete with Undo, and approve.
class CommentItem extends StatefulWidget {
  const CommentItem({super.key, required this.comment, required this.list, this.onReply, this.parent});

  final Comment comment;
  final CommentListController list;
  final VoidCallback? onReply;

  /// For replies: the top-level list whose reply count changes.
  final CommentListController? parent;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _isEditing = false;

  Future<void> _delete() async {
    final comment = widget.comment;
    final details = context.read<VideoDetailsController>();
    final list = widget.list;
    final parent = widget.parent;
    void adjust(int delta) {
      details.adjustCommentsCount(delta);
      if (comment.parentId != null) parent?.adjustReplies(comment.parentId!, delta);
    }

    try {
      final index = await list.remove(comment);
      adjust(-1);
      showUndoToast(CommentMessages.deleted, () async {
        try {
          await list.restore(comment, index);
          adjust(1);
        } catch (error) {
          showToast(ToastType.error, errorMessageOf(error));
        }
      });
    } catch (error) {
      showToast(ToastType.error, errorMessageOf(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final user = context.watch<AuthController>().user;
    final videoOwnerId = context.select<VideoDetailsController, String?>((details) => details.video?.owner.id);
    final isAuthor = user?.id == comment.author.id;
    // The author, the video owner (their own post), or an admin, as on the server.
    final canDelete = isAuthor || (user != null && user.id == videoOwnerId) || (user?.isAdmin ?? false);
    if (_isEditing) {
      return InlineEditor(
        initial: comment.content,
        maxLength: TextLimits.commentMax,
        onCancel: () => setState(() => _isEditing = false),
        onSave: (value) async {
          if (await runWithFeedback(context, () => widget.list.edit(comment, value)) && mounted) setState(() => _isEditing = false);
        },
      );
    }
    return CommentTile(
      comment: comment,
      onReply: user == null ? null : widget.onReply,
      onApprove: comment.isPendingApproval && user?.id == videoOwnerId ? () => runWithFeedback(context, () => widget.list.approve(comment)) : null,
      actions: ActionSheetButton(tooltip: CommentMessages.actions, items: [
        if (isAuthor) ActionItem(label: CommentMessages.edit, icon: Icons.edit_outlined, onSelected: () => setState(() => _isEditing = true)),
        if (canDelete) ActionItem(label: CommentMessages.delete, icon: Icons.delete_outline, isDanger: true, onSelected: _delete),
      ]),
    );
  }
}
