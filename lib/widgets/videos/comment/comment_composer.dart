import 'package:flutter/material.dart';

import '../../../constants/common/limits_constants.dart';
import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../validations/videos/video/video_validation.dart';

/// Text box with a send button that spins and ignores taps while posting.
class CommentComposer extends StatefulWidget {
  const CommentComposer({super.key, required this.onSubmit, this.isPosting = false, this.hint = AppMessages.commentHint});

  /// Resolves to true when the comment was posted, so the field can be cleared.
  final Future<bool> Function(String content) onSubmit;
  final bool isPosting;
  final String hint;

  @override
  State<CommentComposer> createState() => _CommentComposerState();
}

class _CommentComposerState extends State<CommentComposer> {
  final TextEditingController _text = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSending || !isValidComment(_text.text)) return;
    setState(() => _isSending = true);
    try {
      if (await widget.onSubmit(_text.text)) _text.clear();
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _isSending || widget.isPosting;
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Expanded(
        child: TextField(
          controller: _text,
          maxLength: TextLimits.commentMax,
          minLines: 1,
          maxLines: 4,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(hintText: widget.hint, counterText: '', isDense: true),
        ),
      ),
      const SizedBox(width: Spacing.sm),
      IconButton.filled(
        tooltip: AppMessages.commentPost,
        onPressed: isBusy ? null : _submit,
        icon: isBusy ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
      ),
    ]);
  }
}
