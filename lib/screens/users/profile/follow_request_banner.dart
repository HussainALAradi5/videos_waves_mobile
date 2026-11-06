import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/social/social_messages_constants.dart';
import '../../../controllers/users/profile/profile_controller.dart';
import '../../../enums/common/button_tone.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/buttons/app_button.dart';

/// On the profile of someone who asked to follow you: Accept or Decline right there.
class FollowRequestBanner extends StatelessWidget {
  const FollowRequestBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    final profile = controller.profile;
    if (profile == null || !profile.requestedYou) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Expanded(child: Text(SocialMessages.wantsToFollow(profile.user.userName), style: const TextStyle(fontWeight: FontWeight.w600))),
        AppButton(label: SocialMessages.accept, tone: ButtonTone.gradient, onPressed: () => runWithFeedback(context, () => controller.answerRequest(accept: true))),
        const SizedBox(width: Spacing.xs),
        AppButton(label: SocialMessages.decline, tone: ButtonTone.secondary, onPressed: () => runWithFeedback(context, () => controller.answerRequest(accept: false))),
      ]),
    );
  }
}
