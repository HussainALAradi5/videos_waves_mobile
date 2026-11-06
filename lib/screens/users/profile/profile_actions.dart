import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/admin_users/admin_users_constants.dart';
import '../../../constants/users/social/social_messages_constants.dart';
import '../../../enums/users/roles/role.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../controllers/users/profile/profile_controller.dart';
import '../../../enums/common/button_tone.dart';
import '../../../globals/app_dependencies.dart';
import '../../../models/common/ui/action_item.dart';
import '../../../models/users/profile/profile.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/buttons/app_button.dart';
import '../../../widgets/common/dialogs/confirm_dialog.dart';
import '../../../widgets/common/menus/action_sheet_button.dart';
import '../../../widgets/users/social/follow_button.dart';

/// Edit profile for yourself; Follow, Message, and the block and restrict menu for others.
class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key, required this.profile});

  final Profile profile;

  Future<void> _message(BuildContext context) async {
    final router = GoRouter.of(context);
    final conversations = context.read<AppDependencies>().conversationService;
    await runWithFeedback(context, () async {
      final conversation = await conversations.startDirect(profile.user.userName);
      router.push(AppRoutes.thread(conversation.id));
    });
  }

  Future<void> _block(BuildContext context, ProfileController controller) async {
    if (!profile.isBlocked) {
      final isConfirmed = await ConfirmDialog.show(context, title: SocialMessages.blockTitle, message: SocialMessages.blockBody, confirmLabel: SocialMessages.block);
      if (!isConfirmed || !context.mounted) return;
    }
    await runWithFeedback(context, () => controller.setBlocked(!profile.isBlocked));
  }

  @override
  Widget build(BuildContext context) {
    if (profile.isMe) {
      return SizedBox(
        width: double.infinity,
        child: AppButton(label: SocialMessages.editProfile, tone: ButtonTone.secondary, onPressed: () async => context.push(AppRoutes.settings)),
      );
    }
    final controller = context.read<ProfileController>();
    final isSignedIn = context.select<AuthController, bool>((auth) => auth.isAuthenticated);
    final isAdmin = context.select<AuthController, bool>((auth) => auth.isAdmin);
    Future<void> requireSignIn(Future<void> Function() action) async {
      if (!isSignedIn) {
        context.push('${AppRoutes.login}?${AppRoutes.redirectParam}=${Uri.encodeComponent(AppRoutes.user(profile.user.userName))}');
        return;
      }
      await action();
    }

    return Row(children: [
      if (!profile.isBlocked) ...[
        Expanded(
          child: FollowButton(
            isFollowing: profile.isFollowing,
            followsYou: profile.followsYou,
            onPressed: () => requireSignIn(() => runWithFeedback(context, controller.toggleFollow)),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: AppButton(label: SocialMessages.message, tone: ButtonTone.secondary, onPressed: () => requireSignIn(() => _message(context))),
        ),
      ] else
        Expanded(child: AppButton(label: SocialMessages.unblock, tone: ButtonTone.secondary, onPressed: () => _block(context, controller))),
      if (isSignedIn)
        ActionSheetButton(tooltip: SocialMessages.profileActions, items: [
          ActionItem(
            label: profile.isRestricted ? SocialMessages.unrestrict : SocialMessages.restrict,
            icon: Icons.do_not_disturb_on_outlined,
            onSelected: () => runWithFeedback(context, () => controller.setRestricted(!profile.isRestricted)),
          ),
          if (isAdmin && profile.role != Role.admin)
            ActionItem(
              label: profile.isActive ? AdminUsersMessages.deactivate : AdminUsersMessages.activate,
              icon: profile.isActive ? Icons.person_off_outlined : Icons.person_outline,
              isDanger: profile.isActive,
              onSelected: () => runWithFeedback(context, () => controller.setActive(!profile.isActive)),
            ),
          ActionItem(
            label: profile.isBlocked ? SocialMessages.unblock : SocialMessages.block,
            icon: Icons.block,
            isDanger: !profile.isBlocked,
            onSelected: () => _block(context, controller),
          ),
        ]),
    ]);
  }
}
