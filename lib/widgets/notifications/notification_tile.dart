import 'package:flutter/material.dart';

import '../../constants/notifications/notification_constants.dart';
import '../../models/notifications/app_notification.dart';
import '../../utilities/format/formatters.dart';
import '../common/avatars/user_avatar.dart';
import '../../constants/common/gradients_constants.dart';

/// One notification: who, a coloured kind badge, the text, when, and a dot until it is read.
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final look = NotificationLooks.byKind[notification.kind]!;
    final actor = notification.actor;
    return Material(
      color: notification.isRead ? Colors.transparent : scheme.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(children: [
            Stack(clipBehavior: Clip.none, children: [
              actor == null
                  ? Container(width: 44, height: 44, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppGradients.brand), child: const Icon(Icons.notifications, color: Colors.white))
                  : UserAvatar(user: actor, size: 44),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(color: look.color, shape: BoxShape.circle, border: Border.all(color: scheme.surface, width: 2)),
                  child: Icon(look.icon, size: 11, color: Colors.white),
                ),
              ),
            ]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(notification.message, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w600)),
                Text(formatRelative(notification.createdAt), style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            if (!notification.isRead) Container(width: 8, height: 8, decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle)),
          ]),
        ),
      ),
    );
  }
}
