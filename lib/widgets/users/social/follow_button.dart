import 'package:flutter/material.dart';

import '../../../constants/users/social/social_messages_constants.dart';
import '../../../enums/common/button_tone.dart';
import '../../common/buttons/app_button.dart';

/// Gradient Follow, or a quiet Following once you follow them.
class FollowButton extends StatelessWidget {
  const FollowButton({super.key, required this.isFollowing, required this.onPressed, this.followsYou = false});

  final bool isFollowing;
  final bool followsYou;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final label = isFollowing ? SocialMessages.followingLabel : (followsYou ? SocialMessages.followBack : SocialMessages.follow);
    return AppButton(label: label, tone: isFollowing ? ButtonTone.secondary : ButtonTone.gradient, onPressed: onPressed);
  }
}
