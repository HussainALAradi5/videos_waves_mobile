import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/common/ui_constants.dart';
import '../../constants/notifications/notification_constants.dart';
import '../../controllers/chat/realtime/chat_socket_controller.dart';
import '../../controllers/notifications/notification_list_controller.dart';
import '../../controllers/users/social/follow_request_controller.dart';
import '../../enums/notifications/notification_filter.dart';
import '../../globals/app_dependencies.dart';
import '../../models/common/ui/dropdown_option.dart';
import '../../utilities/ui/feedback_utility.dart';
import '../../widgets/common/feedback/empty_view.dart';
import '../../widgets/common/layout/constrained_content.dart';
import '../../widgets/common/lists/paged_list_view.dart';
import '../../widgets/common/motion/fade_slide_in.dart';
import '../../widgets/common/tabs/segmented_tabs.dart';
import '../../widgets/notifications/notification_tile.dart';
import 'follow_requests_section.dart';

const List<DropdownOption<NotificationFilter>> _filters = [
  DropdownOption(value: NotificationFilter.all, label: NotificationMessages.all),
  DropdownOption(value: NotificationFilter.unread, label: NotificationMessages.unread),
];

/// Follow requests on top, then every notification (or only unread), newest first.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = context.read<AppDependencies>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationListController(dependencies.notificationService)..loadFirstPage()),
        ChangeNotifierProvider(create: (_) => FollowRequestController(dependencies.socialService)..loadFirstPage()),
      ],
      child: const _NotificationsBody(),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody();

  @override
  Widget build(BuildContext context) {
    final list = context.watch<NotificationListController>();
    final badge = context.read<ChatSocketController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(NotificationMessages.title, style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            tooltip: NotificationMessages.markAllRead,
            icon: const Icon(Icons.done_all),
            onPressed: () async {
              if (await runWithFeedback(context, list.markAllRead, successMessage: NotificationMessages.allRead)) badge.refreshNotifications();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.sm),
            child: SegmentedTabs(options: _filters, value: list.filter, onChanged: list.setFilter),
          ),
        ),
      ),
      body: ConstrainedContent(
        child: Column(children: [
          const Padding(padding: EdgeInsets.fromLTRB(Spacing.md, Spacing.sm, Spacing.md, 0), child: FollowRequestsSection()),
          Expanded(
            child: PagedListView(
              controller: list,
              empty: const EmptyView(title: NotificationMessages.empty, message: NotificationMessages.emptyHint, icon: Icons.notifications_none),
              itemBuilder: (context, notification) => FadeSlideIn(
                child: NotificationTile(
                  notification: notification,
                  onTap: () async {
                    await list.markRead(notification);
                    badge.refreshNotifications();
                    if (context.mounted) context.push(notification.link);
                  },
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
