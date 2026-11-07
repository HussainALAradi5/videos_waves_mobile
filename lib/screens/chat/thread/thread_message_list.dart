import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/chat/thread/thread_controller.dart';
import '../../../enums/chat/conversation/chat_background.dart';
import '../../../enums/chat/conversation/member_role.dart';
import '../../../utilities/chat/conversation_utility.dart';
import '../../../utilities/format/formatters.dart';
import '../../../widgets/chat/message/message_bubble.dart';
import '../../../widgets/chat/message/system_notice.dart';
import '../../../widgets/chat/message/typing_dots.dart';
import '../../../widgets/chat/thread/chat_background_layer.dart';
import '../../../widgets/common/waves/wave_loader.dart';
import 'message_actions.dart';

/// Newest at the bottom on your wallpaper; scrolling up loads older messages. Shows day labels, ticks, typing, and Seen.
class ThreadMessageList extends StatelessWidget {
  const ThreadMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final thread = context.watch<ThreadController>();
    final messages = thread.messages;
    final members = thread.conversation?.members ?? const [];
    final isGroup = thread.conversation?.isGroup ?? false;
    final adminIds = {for (final member in members) if (member.role == MemberRole.admin) member.user.id};
    final lastMineIndex = messages.indexWhere((message) => message.sender.id == thread.myUserId && !message.isSystem);
    final hasTyping = thread.typingUserIds.isNotEmpty;
    final offset = hasTyping ? 1 : 0;
    return ChatBackgroundLayer(
      background: thread.conversation?.background ?? ChatBackground.none,
      child: NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 300) thread.loadOlder();
        return false;
      },
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.md),
        itemCount: messages.length + offset + (thread.hasMore ? 1 : 0),
        itemBuilder: (context, position) {
          if (hasTyping && position == 0) return const Align(alignment: Alignment.centerLeft, child: TypingDots());
          final index = position - offset;
          if (index >= messages.length) return const Center(child: Padding(padding: EdgeInsets.all(Spacing.sm), child: WaveLoader(size: 20)));
          final message = messages[index];
          final older = index + 1 < messages.length ? messages[index + 1] : null;
          final newer = index > 0 ? messages[index - 1] : null;
          final isNewDay = older == null || !_sameDay(older.createdAt, message.createdAt);
          final isMine = message.sender.id == thread.myUserId;
          final endsRun = newer == null || newer.sender.id != message.sender.id || newer.isSystem;
          final seenCount = index == lastMineIndex ? countSeenBy(message, members) : 0;
          return Column(key: ValueKey(message.id), children: [
            if (isNewDay) Padding(padding: const EdgeInsets.all(Spacing.sm), child: Text(formatDate(message.createdAt), style: Theme.of(context).textTheme.bodySmall)),
            if (message.isSystem)
              SystemNotice(message: message)
            else
              MessageBubble(
                message: message,
                isMine: isMine,
                showAvatar: !isMine && endsRun,
                // A group notice ("admin created the group") breaks the run, so the next message shows its sender again.
                showName: isGroup && !isMine && (older == null || older.isSystem || older.sender.id != message.sender.id),
                onLongPress: () => showMessageActions(context, thread, message),
                onSwipeReply: () => thread.setReplyTo(message),
                readState: isMine ? readStateOf(message, members) : null,
                isSenderAdmin: adminIds.contains(message.sender.id),
              ),
            if (seenCount > 0)
              Align(
                alignment: Alignment.centerRight,
                child: Text(isGroup ? ChatMessages.seenBy(seenCount) : ChatMessages.seen, style: Theme.of(context).textTheme.bodySmall),
              ),
          ]);
        },
      ),
      ),
    );
  }

  static bool _sameDay(DateTime a, DateTime b) {
    final left = a.toLocal();
    final right = b.toLocal();
    return left.year == right.year && left.month == right.month && left.day == right.day;
  }
}
