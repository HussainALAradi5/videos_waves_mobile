import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/social/social_messages_constants.dart';
import '../../../globals/app_dependencies.dart';
import '../../../models/users/profile/profile.dart';
import '../../../widgets/common/avatars/user_avatar.dart';
import '../../../widgets/users/profile/profile_count.dart';
import '../../../widgets/users/social/user_list_sheet.dart';
import 'profile_actions.dart';

/// Avatar, counters, bio, and the follow and message actions.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final social = context.read<AppDependencies>().socialService;
    final userName = profile.user.userName;
    final muted = Theme.of(context).textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          UserAvatar(user: profile.user, size: 84, hasRing: true),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ProfileCount(value: profile.videosCount, label: SocialMessages.videos),
              ProfileCount(
                value: profile.followersCount,
                label: SocialMessages.followers,
                onTap: () => UserListSheet.show(context, title: SocialMessages.followers, fetch: (_, page) => social.followers(userName, page)),
              ),
              ProfileCount(
                value: profile.followingCount,
                label: SocialMessages.followingTitle,
                onTap: () => UserListSheet.show(context, title: SocialMessages.followingTitle, fetch: (_, page) => social.following(userName, page)),
              ),
            ]),
          ),
        ]),
        const SizedBox(height: Spacing.sm),
        Row(children: [
          Text(userName, style: const TextStyle(fontWeight: FontWeight.w700)),
          if (profile.followsYou && !profile.isMe) ...[const SizedBox(width: Spacing.sm), Text(SocialMessages.followsYou, style: muted)],
        ]),
        if (profile.bio.isNotEmpty) Padding(padding: const EdgeInsets.only(top: Spacing.xs), child: Text(profile.bio)),
        if (profile.isBlocked) Padding(padding: const EdgeInsets.only(top: Spacing.sm), child: Text(SocialMessages.blockedNotice, style: muted)),
        if (profile.isRestricted) Padding(padding: const EdgeInsets.only(top: Spacing.sm), child: Text(SocialMessages.restrictedNotice, style: muted)),
        const SizedBox(height: Spacing.md),
        ProfileActions(profile: profile),
      ]),
    );
  }
}
