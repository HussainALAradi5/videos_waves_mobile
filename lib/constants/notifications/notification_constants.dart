import 'package:flutter/material.dart';

import '../../enums/notifications/notification_kind.dart';
import '../common/app_colors_constants.dart';

/// The small badge on each notification's avatar, and the screen's text.
class NotificationLooks {
  const NotificationLooks._();

  static const Map<NotificationKind, ({IconData icon, Color color})> byKind = {
    NotificationKind.follow: (icon: Icons.person_add_alt_1, color: AppColors.brandStart),
    NotificationKind.followRequest: (icon: Icons.person_add_alt_1, color: AppColors.pending),
    NotificationKind.followAccepted: (icon: Icons.how_to_reg, color: AppColors.accepted),
    NotificationKind.like: (icon: Icons.favorite, color: AppColors.like),
    NotificationKind.comment: (icon: Icons.chat_bubble, color: AppColors.brandStart),
    NotificationKind.reply: (icon: Icons.reply, color: AppColors.brandMiddle),
    NotificationKind.groupAdded: (icon: Icons.groups, color: Color(0xFF14B8A6)),
    NotificationKind.adminAccepted: (icon: Icons.verified_user, color: AppColors.accepted),
    NotificationKind.adminRejected: (icon: Icons.gpp_bad, color: AppColors.rejected),
  };
}

class NotificationMessages {
  const NotificationMessages._();

  static const String title = 'Notifications';
  static const String all = 'All';
  static const String unread = 'Unread';
  static const String markAllRead = 'Mark all read';
  static const String allRead = 'All caught up';
  static const String empty = 'Nothing new';
  static const String emptyHint = 'When people follow you or react to your videos, it shows up here.';
  static const String open = 'Open';
  static const String requestsTitle = 'Follow requests';
  static const String accept = 'Accept';
  static const String decline = 'Decline';
  static const String declined = 'Request removed';
  static String accepted(String name) => '$name now follows you';
}
