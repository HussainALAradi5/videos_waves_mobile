import 'package:flutter/material.dart';

import '../../../constants/common/app_colors_constants.dart';
import '../../../constants/common/gradients_constants.dart';
import '../../../constants/chat/chat_messages_constants.dart';
import '../../../models/chat/conversation/conversation.dart';
import '../../../utilities/format/formatters.dart';
import '../../common/avatars/user_avatar.dart';

/// Inbox row: avatar with presence, name, latest preview, time, and an unread dot.
class ConversationTile extends StatelessWidget {
  const ConversationTile({super.key, required this.conversation, required this.onTap, this.onOptions});

  final Conversation conversation;
  final VoidCallback onTap;

  /// Long-press opens the chat options.
  final VoidCallback? onOptions;

  @override
  Widget build(BuildContext context) {
    final partner = conversation.partner;
    final isUnread = conversation.unreadCount > 0;
    final muted = Theme.of(context).textTheme.bodySmall;
    final avatar = conversation.isGroup || partner == null
        ? const CircleAvatar(radius: 26, child: DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.brand, shape: BoxShape.circle), child: SizedBox.expand(child: Icon(Icons.groups, color: Colors.white))))
        : UserAvatar(user: partner.user, size: 52, isOnline: partner.isOnline, presence: partner.presence);
    final subtitle = conversation.lastPreview ?? (conversation.isGroup ? ChatMessages.members(conversation.membersCount + 1) : '');
    return ListTile(
      onTap: onTap,
      onLongPress: onOptions,
      leading: avatar,
      title: Text(conversation.displayTitle, style: TextStyle(fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500)),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: isUnread ? const TextStyle(fontWeight: FontWeight.w600) : null),
      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
        if (conversation.lastMessageAt != null) Text(formatRelative(conversation.lastMessageAt!), style: muted),
        const SizedBox(height: 4),
        if (isUnread) Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.brandStart, shape: BoxShape.circle)),
        if (conversation.isMuted) Icon(Icons.notifications_off_outlined, size: 14, color: muted?.color),
      ]),
    );
  }
}

