import 'package:flutter/material.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/common/ui_constants.dart';

class ReplyPreview extends StatelessWidget {
  const ReplyPreview({super.key, required this.userName, required this.onClose});

  final String userName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: Row(children: [
        Icon(Icons.reply, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: Spacing.xs),
        Expanded(child: Text(ChatMessages.replyingTo(userName), style: Theme.of(context).textTheme.bodySmall)),
        IconButton(icon: const Icon(Icons.close, size: 18), onPressed: onClose),
      ]),
    );
  }
}
