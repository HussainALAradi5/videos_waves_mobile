import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../controllers/chat/thread/thread_controller.dart';
import '../../../utilities/chat/conversation_utility.dart';
import '../../../widgets/common/avatars/user_avatar.dart';
import '../../../constants/chat/chat_options_constants.dart';
import '../../../widgets/chat/options/chat_options_sheet.dart';

/// Avatar and name, with "typing..." or their status (Online · custom line) under it.
class ThreadAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThreadAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final thread = context.watch<ThreadController>();
    final conversation = thread.conversation;
    if (conversation == null) return AppBar();
    final partner = conversation.partner;
    final status = thread.typingUserIds.isNotEmpty
        ? ChatMessages.typing
        : conversation.isGroup
            ? ChatMessages.members(conversation.membersCount + 1)
            : (partner == null ? null : describePresence(partner, ChatMessages.presenceLabels));
    return AppBar(
      titleSpacing: 0,
      title: InkWell(
        onTap: partner == null ? null : () => context.push(AppRoutes.user(partner.user.userName)),
        child: Row(children: [
          if (partner != null) UserAvatar(user: partner.user, size: 36, isOnline: partner.isOnline, presence: partner.presence) else const Icon(Icons.groups),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(conversation.displayTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
              if (status != null) Text(status, style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
        ]),
      ),
      actions: [
        IconButton(
          tooltip: ChatOptionsMessages.menu,
          icon: const Icon(Icons.more_horiz),
          onPressed: () async {
            final thread = context.read<ThreadController>();
            final router = GoRouter.of(context);
            final result = await showChatOptions(context, conversation);
            // After deleting or leaving, go back to the inbox; after a mute or background change, reload the chat.
            if (result == ChatOptionResult.removed) {
              router.canPop() ? router.pop() : router.go(AppRoutes.messages);
            } else if (result != null) {
              await thread.load();
            }
          },
        ),
      ],
    );
  }
}
