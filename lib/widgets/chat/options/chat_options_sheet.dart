import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_options_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../enums/chat/conversation/mute_duration.dart';
import '../../../globals/app_dependencies.dart';
import '../../../models/chat/conversation/conversation.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../common/dialogs/confirm_dialog.dart';

/// What a chat option did, so the caller can refresh the chat or leave the screen.
enum ChatOptionResult { muteChanged, removed }

typedef _Option = ({String label, IconData icon, bool isDanger, Future<ChatOptionResult?> Function() run});

/// The chat options sheet (thread header and long-press on an inbox row): mute, leave group, delete chat.
Future<ChatOptionResult?> showChatOptions(BuildContext context, Conversation conversation) async {
  final conversations = context.read<AppDependencies>().conversationService;
  final myUserId = context.read<AuthController>().user?.id;
  final title = conversation.displayTitle;

  Future<ChatOptionResult?> mute(MuteDuration duration) async {
    final isDone = await runWithFeedback(
      context,
      () => conversations.mute(conversation.id, duration),
      successMessage: duration == MuteDuration.off ? ChatOptionsMessages.unmuted : ChatOptionsMessages.muted,
    );
    return isDone ? ChatOptionResult.muteChanged : null;
  }

  Future<ChatOptionResult?> confirmThen(String heading, String body, String label, Future<void> Function() action, String success) async {
    final isConfirmed = await ConfirmDialog.show(context, title: heading, message: body, confirmLabel: label);
    if (!isConfirmed || !context.mounted) return null;
    return await runWithFeedback(context, action, successMessage: success) ? ChatOptionResult.removed : null;
  }

  final List<_Option> options = [
    if (conversation.isMuted)
      (label: ChatOptionsMessages.unmute, icon: Icons.notifications_active_outlined, isDanger: false, run: () => mute(MuteDuration.off))
    else ...[
      (label: ChatOptionsMessages.mute8h, icon: Icons.notifications_off_outlined, isDanger: false, run: () => mute(MuteDuration.eightHours)),
      (label: ChatOptionsMessages.mute1w, icon: Icons.notifications_off_outlined, isDanger: false, run: () => mute(MuteDuration.oneWeek)),
      (label: ChatOptionsMessages.muteAlways, icon: Icons.notifications_off_outlined, isDanger: false, run: () => mute(MuteDuration.always)),
    ],
    if (conversation.isGroup && myUserId != null)
      (
        label: ChatOptionsMessages.leaveGroup,
        icon: Icons.logout,
        isDanger: true,
        run: () => confirmThen(ChatOptionsMessages.leaveTitle(title), ChatOptionsMessages.leaveBody, ChatOptionsMessages.leaveGroup,
            () => conversations.leave(conversation.id, myUserId), ChatOptionsMessages.left(title)),
      ),
    (
      label: ChatOptionsMessages.deleteChat,
      icon: Icons.delete_outline,
      isDanger: true,
      run: () => confirmThen(ChatOptionsMessages.deleteTitle(title), ChatOptionsMessages.deleteBody, ChatOptionsMessages.deleteChat,
          () => conversations.hide(conversation.id), ChatOptionsMessages.deleted),
    ),
  ];
  final chosen = await showModalBottomSheet<_Option>(
    context: context,
    showDragHandle: true,
    builder: (sheet) {
      final error = Theme.of(sheet).colorScheme.error;
      return SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final option in options)
            ListTile(
              leading: Icon(option.icon, color: option.isDanger ? error : null),
              title: Text(option.label, style: TextStyle(color: option.isDanger ? error : null)),
              onTap: () => Navigator.of(sheet).pop(option),
            ),
        ]),
      );
    },
  );
  if (chosen == null || !context.mounted) return null;
  return chosen.run();
}
