import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/common/routes_constants.dart';
import '../../constants/notifications/notification_constants.dart';
import '../../controllers/chat/realtime/chat_socket_controller.dart';

/// The bell with the unread badge; opens the notifications screen.
class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select<ChatSocketController, int>((chat) => chat.notificationCount);
    return IconButton(
      tooltip: NotificationMessages.title,
      onPressed: () => context.push(AppRoutes.notifications),
      icon: Badge(isLabelVisible: count > 0, label: Text(count > 99 ? '99+' : '$count'), child: const Icon(Icons.notifications_outlined)),
    );
  }
}
