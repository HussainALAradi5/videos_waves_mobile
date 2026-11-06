import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/ui_constants.dart';
import '../../../constants/videos/comment/comment_messages_constants.dart';
import '../../../controllers/videos/comment/comment_list_controller.dart';
import '../../../controllers/videos/video/video_details_controller.dart';
import '../../../globals/app_dependencies.dart';
import '../../../models/videos/comment/comment.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/videos/comment/comment_composer.dart';
import 'comment_item.dart';

/// A top-level comment with its replies, which load when opened.
class CommentThread extends StatefulWidget {
  const CommentThread({super.key, required this.comment, required this.list});

  final Comment comment;
  final CommentListController list;

  @override
  State<CommentThread> createState() => _CommentThreadState();
}

class _CommentThreadState extends State<CommentThread> {
  CommentListController? _replies;
  bool _isOpen = false;
  bool _isReplying = false;

  @override
  void dispose() {
    _replies?.dispose();
    super.dispose();
  }

  CommentListController _ensureReplies() => _replies ??= CommentListController(
        context.read<AppDependencies>().commentService,
        widget.list.videoId,
        parentId: widget.comment.id,
      )..loadFirstPage();

  void _toggleReplies() => setState(() {
        _isOpen = !_isOpen;
        if (_isOpen) _ensureReplies();
      });

  Future<bool> _reply(String content) {
    final replies = _ensureReplies();
    final details = context.read<VideoDetailsController>();
    return runWithFeedback(context, () async {
      await replies.add(content);
      widget.list.adjustReplies(widget.comment.id, 1);
      details.adjustCommentsCount(1);
      setState(() {
        _isOpen = true;
        _isReplying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final replies = _replies;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CommentItem(comment: comment, list: widget.list, onReply: () => setState(() => _isReplying = !_isReplying)),
      Padding(
        padding: const EdgeInsets.only(left: 48),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_isReplying) CommentComposer(hint: CommentMessages.replyHint, onSubmit: _reply),
          if (comment.repliesCount > 0)
            TextButton(
              onPressed: _toggleReplies,
              child: Text(_isOpen ? CommentMessages.hideReplies : CommentMessages.viewReplies(comment.repliesCount)),
            ),
          if (_isOpen && replies != null)
            ListenableBuilder(
              listenable: replies,
              builder: (context, _) => Column(children: [
                for (final reply in replies.items) CommentItem(key: ValueKey(reply.id), comment: reply, list: replies, parent: widget.list),
                if (replies.hasMore) TextButton(onPressed: replies.loadNextPage, child: Text(CommentMessages.viewReplies(comment.repliesCount - replies.items.length))),
              ]),
            ),
          const SizedBox(height: Spacing.xs),
        ]),
      ),
    ]);
  }
}
