import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/common/routes_constants.dart';
import '../../../models/users/profile/user_summary.dart';
import '../../common/avatars/user_avatar.dart';
import 'follow_button.dart';

/// A person in a list: avatar and name open the profile, with a Follow button unless it is you.
class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.summary, required this.onToggleFollow});

  final UserSummary summary;
  final Future<void> Function() onToggleFollow;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: UserAvatar(user: summary.user, size: 44),
      title: Text(summary.user.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () => context.push(AppRoutes.user(summary.user.userName)),
      trailing: summary.isMe ? null : FollowButton(isFollowing: summary.isFollowing, onPressed: onToggleFollow),
    );
  }
}
