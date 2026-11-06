import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/chat/message/message_limits_constants.dart';
import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/chat/thread/thread_controller.dart';
import '../../../enums/chat/message/message_kind.dart';
import '../../../models/chat/message/message.dart';
import '../../../utilities/chat/conversation_utility.dart';
import '../../../utilities/ui/feedback_utility.dart';

/// Long-press sheet: the emoji bar, then Reply, Copy, Edit (15 minutes), Unsend (until seen), and Delete for me.
Future<void> showMessageActions(BuildContext context, ThreadController thread, Message message) async {
  if (message.isUnsent) return;
  // Keep the keyboard closed: otherwise focus returns to the composer when the sheet closes.
  FocusManager.instance.primaryFocus?.unfocus();
  final isMine = message.sender.id == thread.myUserId;
  // Unsend only until someone else has read it (the server enforces the same rule).
  final canUnsend = isMine && countSeenBy(message, thread.conversation?.members ?? const []) == 0;
  final canEdit = isMine && message.kind == MessageKind.text && DateTime.now().difference(message.createdAt) < MessageLimits.editWindow;
  final action = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheet) {
      final error = Theme.of(sheet).colorScheme.error;
      Widget tile(String value, IconData icon, String label, {bool isDanger = false}) => ListTile(
            leading: Icon(icon, color: isDanger ? error : null),
            title: Text(label, style: TextStyle(color: isDanger ? error : null)),
            onTap: () => Navigator.of(sheet).pop(value),
          );
      return SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            for (final emoji in MessageLimits.reactions)
              InkResponse(
                onTap: () => Navigator.of(sheet).pop('react:$emoji'),
                child: AnimatedScale(
                  scale: message.myReaction == emoji ? 1.3 : 1,
                  duration: const Duration(milliseconds: 150),
                  child: Padding(padding: const EdgeInsets.all(Spacing.xs), child: Text(emoji, style: const TextStyle(fontSize: 28))),
                ),
              ),
          ]),
          const Divider(),
          tile('reply', Icons.reply, ChatMessages.reply),
          if (message.body != null) tile('copy', Icons.copy, ChatMessages.copy),
          if (canEdit) tile('edit', Icons.edit_outlined, ChatMessages.edit),
          if (canUnsend) tile('unsend', Icons.undo, ChatMessages.unsend, isDanger: true),
          tile('delete', Icons.delete_outline, ChatMessages.deleteForMe, isDanger: true),
        ]),
      );
    },
  );
  if (action == null || !context.mounted) return;
  if (action.startsWith('react:')) {
    await runWithFeedback(context, () => thread.react(message, action.substring(6)));
  } else if (action == 'reply') {
    thread.setReplyTo(message);
  } else if (action == 'copy') {
    await Clipboard.setData(ClipboardData(text: message.body ?? ''));
    if (context.mounted) showMessage(context, ChatMessages.copied);
  } else if (action == 'edit') {
    final body = await _askEdit(context, message.body ?? '');
    if (body != null && context.mounted) await runWithFeedback(context, () => thread.edit(message, body));
  } else if (action == 'unsend') {
    thread.unsend(message);
  } else if (action == 'delete') {
    await runWithFeedback(context, () => thread.deleteForMe(message));
  }
}

Future<String?> _askEdit(BuildContext context, String initial) {
  final text = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: const Text(ChatMessages.editMessage),
      content: TextField(controller: text, autofocus: true, minLines: 1, maxLines: 5, maxLength: MessageLimits.bodyMax),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialog).pop(), child: const Text(AppMessages.cancel)),
        FilledButton(onPressed: () => Navigator.of(dialog).pop(text.text.trim().isEmpty ? null : text.text.trim()), child: const Text(AppMessages.save)),
      ],
    ),
  ).whenComplete(text.dispose);
}
