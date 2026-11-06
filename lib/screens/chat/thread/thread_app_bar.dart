import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../controllers/chat/thread/thread_controller.dart';
import '../../../utilities/chat/conversation_utility.dart';
import '../../../widgets/common/avatars/user_avatar.dart';

/// Avatar and name, with "typing..." or "Active now" under it.
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
            : (isPartnerOnline(conversation) ? ChatMessages.online : null);
    return AppBar(
      titleSpacing: 0,
      title: InkWell(
        onTap: partner == null ? null : () => context.push(AppRoutes.user(partner.user.userName)),
        child: Row(children: [
          if (partner != null) UserAvatar(user: partner.user, size: 36, isOnline: partner.isOnline) else const Icon(Icons.groups),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(conversation.displayTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
              if (status != null) Text(status, style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
        ]),
      ),
    );
  }
}
