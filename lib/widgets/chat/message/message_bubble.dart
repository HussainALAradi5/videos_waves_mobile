import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../controllers/users/settings/settings_controller.dart';
import '../../../enums/chat/message/message_kind.dart';
import '../../../enums/chat/message/read_state.dart';
import '../../../models/chat/message/message.dart';
import '../../../models/users/settings/user_settings.dart';
import '../../../utilities/chat/bubble_look_utility.dart';
import '../../../utilities/format/formatters.dart';
import '../../common/avatars/user_avatar.dart';
import '../../common/motion/fade_slide_in.dart';
import 'message_attachments.dart';
import '../conversation/admin_badge.dart';
import 'message_ticks.dart';
import 'voice_note_player.dart';

/// A chat bubble in the reader's chosen shape and colours (yours right, theirs left), with reply quote, ticks, and reactions.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.showAvatar,
    required this.showName,
    required this.onLongPress,
    required this.onSwipeReply,
    this.readState,
    this.isSenderAdmin = false,
  });

  final Message message;
  final bool isMine;
  final bool showAvatar;
  final bool showName;
  final VoidCallback onLongPress;
  final VoidCallback onSwipeReply;

  /// Your messages only: the ticks next to the time.
  final ReadState? readState;

  /// Group admins get the Admin badge beside their name.
  final bool isSenderAdmin;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final settings = context.select<SettingsController, UserSettings>((controller) => controller.settings ?? const UserSettings());
    final look = bubbleLook(
      scheme: scheme,
      isMine: isMine,
      isUnsent: message.isUnsent,
      style: settings.bubbleStyle,
      myColor: settings.bubbleColor,
      othersColor: settings.othersBubbleColor,
    );
    final foreground = look.foreground;
    final muted = TextStyle(color: foreground.withValues(alpha: 0.7), fontSize: 11);
    final content = message.isUnsent
        ? Text(ChatMessages.unsent, style: TextStyle(color: foreground.withValues(alpha: 0.7), fontStyle: FontStyle.italic))
        : Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            if (message.replyToPreview != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(border: Border(left: BorderSide(color: foreground.withValues(alpha: 0.6), width: 2))),
                child: Text('${message.replyToSender ?? ''}: ${message.replyToPreview}', maxLines: 2, overflow: TextOverflow.ellipsis, style: muted),
              ),
            if (message.kind == MessageKind.voice && message.attachments.isNotEmpty)
              VoiceNotePlayer(url: message.attachments.first.url, color: foreground)
            else if (message.attachments.isNotEmpty)
              MessageAttachments(attachments: message.attachments, color: foreground),
            if (message.sharedVideoId != null)
              InkWell(
                onTap: () => context.push(AppRoutes.video(message.sharedVideoId!)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.smart_display_outlined, color: foreground),
                  const SizedBox(width: 6),
                  Flexible(child: Text(message.sharedVideoTitle ?? ChatMessages.sharedVideo, style: TextStyle(color: foreground, fontWeight: FontWeight.w600))),
                ]),
              ),
            if (message.body != null && message.kind != MessageKind.voice) Text(message.body!, style: TextStyle(color: foreground)),
          ]);
    final bubble = Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.72),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: look.decoration,
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
        content,
        Row(mainAxisSize: MainAxisSize.min, children: [
          Text('${message.isEdited && !message.isUnsent ? '${ChatMessages.edited} · ' : ''}${formatClock(message.createdAt)}', style: muted),
          if (readState != null && !message.isUnsent) ...[const SizedBox(width: 3), MessageTicks(state: readState!, color: muted.color!)],
        ]),
      ]),
    );
    return FadeSlideIn(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
          if (showName)
            Padding(
              padding: const EdgeInsets.only(left: 44, bottom: 2),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(message.sender.userName, style: Theme.of(context).textTheme.bodySmall),
                if (isSenderAdmin) ...[const SizedBox(width: 6), const AdminBadge()],
              ]),
            ),
          Row(mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end, children: [
            if (!isMine) SizedBox(width: 36, child: showAvatar ? UserAvatar(user: message.sender, size: 28) : null),
            GestureDetector(
              onLongPress: onLongPress,
              onHorizontalDragEnd: (details) {
                if ((details.primaryVelocity ?? 0) > 300) onSwipeReply();
              },
              child: bubble,
            ),
          ]),
          if (message.reactions.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: isMine ? 0 : 40, top: 2),
              child: Wrap(spacing: 4, children: [
                for (final reaction in message.reactions)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: reaction.emoji == message.myReaction ? scheme.primary : scheme.outlineVariant),
                    ),
                    child: Text('${reaction.emoji} ${reaction.count > 1 ? reaction.count : ''}'.trim(), style: const TextStyle(fontSize: 12)),
                  ),
              ]),
            ),
        ]),
      ),
    );
  }
}
