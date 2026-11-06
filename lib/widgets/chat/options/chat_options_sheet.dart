import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/chat/chat_options_constants.dart';
import '../../../constants/users/social/social_messages_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../enums/chat/conversation/mute_duration.dart';
import '../../../globals/app_dependencies.dart';
import '../../../models/chat/conversation/conversation.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../common/dialogs/confirm_dialog.dart';
import 'chat_background_sheet.dart';

/// What a chat option did, so the caller can refresh the chat or leave the screen.
enum ChatOptionResult { muteChanged, backgroundChanged, removed }

const List<({String label, MuteDuration value})> _muteChoices = [
  (label: ChatOptionsMessages.for8h, value: MuteDuration.eightHours),
  (label: ChatOptionsMessages.for1w, value: MuteDuration.oneWeek),
  (label: ChatOptionsMessages.untilUnmute, value: MuteDuration.always),
];

typedef _Option = ({String label, IconData icon, bool isDanger, Future<ChatOptionResult?> Function() run});

/// The chat options sheet (thread header and long-press on an inbox row): mute, background, block (direct chats), leave group, delete chat.
Future<ChatOptionResult?> showChatOptions(BuildContext context, Conversation conversation) async {
  // Keep the keyboard closed: otherwise focus returns to the composer when the sheet closes.
  FocusManager.instance.primaryFocus?.unfocus();
  final dependencies = context.read<AppDependencies>();
  final conversations = dependencies.conversationService;
  final partnerName = conversation.partner?.user.userName;
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

  Future<ChatOptionResult?> chooseMute() async {
    final duration = await showModalBottomSheet<MuteDuration>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(title: Text(ChatOptionsMessages.mute, style: Theme.of(sheet).textTheme.titleMedium)),
          for (final choice in _muteChoices)
            ListTile(leading: const Icon(Icons.schedule), title: Text(choice.label), onTap: () => Navigator.of(sheet).pop(choice.value)),
        ]),
      ),
    );
    return duration == null || !context.mounted ? null : mute(duration);
  }

  Future<ChatOptionResult?> changeBackground() async {
    final picked = await pickChatBackground(context, conversation.background);
    if (picked == null || picked == conversation.background || !context.mounted) return null;
    final isDone = await runWithFeedback(context, () => conversations.setBackground(conversation.id, picked), successMessage: ChatMessages.backgroundSaved);
    return isDone ? ChatOptionResult.backgroundChanged : null;
  }

  Future<ChatOptionResult?> confirmThen(String heading, String body, String label, Future<void> Function() action, String success) async {
    final isConfirmed = await ConfirmDialog.show(context, title: heading, message: body, confirmLabel: label);
    if (!isConfirmed || !context.mounted) return null;
    return await runWithFeedback(context, action, successMessage: success) ? ChatOptionResult.removed : null;
  }

  final List<_Option> options = [
    if (conversation.isMuted)
      (label: ChatOptionsMessages.unmute, icon: Icons.notifications_active_outlined, isDanger: false, run: () => mute(MuteDuration.off))
    else
      (label: ChatOptionsMessages.mute, icon: Icons.notifications_off_outlined, isDanger: false, run: chooseMute),
    (label: ChatMessages.background, icon: Icons.wallpaper_outlined, isDanger: false, run: changeBackground),
    if (conversation.isGroup && myUserId != null)
      (
        label: ChatOptionsMessages.leaveGroup,
        icon: Icons.logout,
        isDanger: true,
        run: () => confirmThen(ChatOptionsMessages.leaveTitle(title), ChatOptionsMessages.leaveBody, ChatOptionsMessages.leaveGroup,
            () => conversations.leave(conversation.id, myUserId), ChatOptionsMessages.left(title)),
      ),
    if (!conversation.isGroup && partnerName != null)
      (
        label: SocialMessages.block,
        icon: Icons.block,
        isDanger: true,
        run: () => confirmThen(SocialMessages.blockTitle, SocialMessages.blockBody, SocialMessages.block,
            () => dependencies.socialService.setBlocked(partnerName, isBlocked: true), SocialMessages.blockedNotice),
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
