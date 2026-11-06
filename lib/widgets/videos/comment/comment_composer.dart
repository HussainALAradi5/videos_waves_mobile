import 'package:flutter/material.dart';

import '../../../constants/common/limits_constants.dart';
import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../validations/videos/video/video_validation.dart';

class CommentComposer extends StatefulWidget {
  const CommentComposer({super.key, required this.onSubmit, this.isPosting = false});

  /// Resolves to true when the comment was posted, so the field can be cleared.
  final Future<bool> Function(String content) onSubmit;
  final bool isPosting;

  @override
  State<CommentComposer> createState() => _CommentComposerState();
}

class _CommentComposerState extends State<CommentComposer> {
  final TextEditingController _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!isValidComment(_text.text)) return;
    if (await widget.onSubmit(_text.text)) _text.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: _text,
            maxLength: TextLimits.commentMax,
            minLines: 1,
            maxLines: 4,
            decoration: const InputDecoration(hintText: AppMessages.commentHint, counterText: ''),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        IconButton.filled(
          tooltip: AppMessages.commentPost,
          onPressed: widget.isPosting ? null : _submit,
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
