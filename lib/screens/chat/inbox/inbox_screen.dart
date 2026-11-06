import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/chat/inbox/inbox_controller.dart';
import '../../../controllers/chat/realtime/chat_socket_controller.dart';
import '../../../enums/chat/conversation/inbox_folder.dart';
import '../../../globals/app_dependencies.dart';
import '../../../models/common/ui/dropdown_option.dart';
import '../../../widgets/chat/conversation/conversation_tile.dart';
import '../../../widgets/common/feedback/empty_view.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import '../../../widgets/common/lists/paged_list_view.dart';
import '../../../widgets/common/motion/fade_slide_in.dart';
import '../../../widgets/common/tabs/segmented_tabs.dart';
import 'new_chat_flow.dart';

const List<DropdownOption<InboxFolder>> _folders = [
  DropdownOption(value: InboxFolder.inbox, label: ChatMessages.inbox),
  DropdownOption(value: InboxFolder.requests, label: ChatMessages.requests),
  DropdownOption(value: InboxFolder.groups, label: ChatMessages.groups),
  DropdownOption(value: InboxFolder.unread, label: ChatMessages.unread),
];

/// The chat list with Inbox, Requests, Groups, and Unread folders.
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final dependencies = context.read<AppDependencies>();
        return InboxController(dependencies.conversationService, dependencies.socketService)..loadFirstPage();
      },
      child: const _InboxBody(),
    );
  }
}

class _InboxBody extends StatelessWidget {
  const _InboxBody();

  Future<void> _open(BuildContext context, String conversationId) async {
    final inbox = context.read<InboxController>();
    final badge = context.read<ChatSocketController>();
    inbox.markReadLocally(conversationId);
    await context.push(AppRoutes.thread(conversationId));
    badge.refreshUnread();
  }

  @override
  Widget build(BuildContext context) {
    final inbox = context.watch<InboxController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(ChatMessages.title, style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [IconButton(tooltip: ChatMessages.newMessage, icon: const Icon(Icons.edit_square), onPressed: () => startNewChat(context))],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.sm),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedTabs(options: _folders, value: inbox.folder, onChanged: inbox.setFolder),
            ),
          ),
        ),
      ),
      body: ConstrainedContent(
        child: PagedListView(
          controller: inbox,
          empty: const EmptyView(title: ChatMessages.noChats, message: ChatMessages.noChatsHint, icon: Icons.forum_outlined),
          itemBuilder: (context, conversation) => FadeSlideIn(
            child: ConversationTile(conversation: conversation, onTap: () => _open(context, conversation.id)),
          ),
        ),
      ),
    );
  }
}
