import 'package:flutter/material.dart';

import '../../../constants/users/social/social_messages_constants.dart';
import '../../../enums/common/button_tone.dart';
import '../../common/buttons/app_button.dart';

/// Gradient Follow; a quiet Following or Requested once sent (tap again to undo).
class FollowButton extends StatelessWidget {
  const FollowButton({super.key, required this.isFollowing, required this.onPressed, this.isRequested = false, this.followsYou = false});

  final bool isFollowing;

  /// A request to this private account is waiting.
  final bool isRequested;
  final bool followsYou;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final label = isFollowing
        ? SocialMessages.followingLabel
        : isRequested
            ? SocialMessages.requested
            : (followsYou ? SocialMessages.followBack : SocialMessages.follow);
    return AppButton(label: label, tone: isFollowing || isRequested ? ButtonTone.secondary : ButtonTone.gradient, onPressed: onPressed);
  }
}
