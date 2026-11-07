import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/videos/video/video_messages_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../controllers/videos/video/video_details_controller.dart';
import '../../../models/common/ui/action_item.dart';
import '../../../models/videos/video/video.dart';
import '../../../utilities/format/formatters.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/avatars/user_avatar.dart';
import '../../../widgets/common/dialogs/confirm_dialog.dart';
import '../../../widgets/common/menus/action_sheet_button.dart';
import '../../../widgets/videos/video/like_button.dart';
import 'video_edit_sheet.dart';

/// Owner avatar and name, the like button, and the owner's (or an admin's) ⋯ menu.
class VideoOwnerRow extends StatelessWidget {
  const VideoOwnerRow({super.key, required this.video});

  final Video video;

  void _like(BuildContext context, VideoDetailsController details) {
    if (!context.read<AuthController>().isAuthenticated) {
      context.push('${AppRoutes.login}?${AppRoutes.redirectParam}=${Uri.encodeComponent(AppRoutes.video(details.videoId))}');
      return;
    }
    runWithFeedback(context, details.toggleLike);
  }

  Future<void> _delete(BuildContext context, VideoDetailsController details) async {
    final router = GoRouter.of(context);
    final isConfirmed = await ConfirmDialog.show(
      context,
      title: VideoMessages.deleteVideoTitle,
      message: VideoMessages.deleteVideoBody,
      confirmLabel: VideoMessages.deleteVideo,
    );
    if (!isConfirmed || !context.mounted) return;
    if (await runWithFeedback(context, details.remove, successMessage: VideoMessages.videoDeleted)) {
      router.canPop() ? router.pop() : router.go(AppRoutes.feed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = context.read<VideoDetailsController>();
    final user = context.watch<AuthController>().user;
    final isOwner = user?.id == video.owner.id;
    final canManage = isOwner || (user?.isAdmin ?? false);
    return Row(children: [
      GestureDetector(
        onTap: () => context.push(AppRoutes.user(video.owner.userName)),
        child: Row(children: [
          UserAvatar(user: video.owner, size: 40, hasRing: true),
          const SizedBox(width: Spacing.sm),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(video.owner.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(formatRelative(video.createdAt), style: Theme.of(context).textTheme.bodySmall),
          ]),
        ]),
      ),
      const Spacer(),
      // Guests can't like (same as the web); the count still shows in the stats row.
      if (user != null) LikeButton(video: video, isBusy: details.isLiking, onPressed: () => _like(context, details)),
      ActionSheetButton(tooltip: VideoMessages.editVideo, items: [
        if (isOwner) ActionItem(label: VideoMessages.editVideo, icon: Icons.edit_outlined, onSelected: () => VideoEditSheet.show(context, details)),
        if (canManage) ActionItem(label: VideoMessages.deleteVideo, icon: Icons.delete_outline, isDanger: true, onSelected: () => _delete(context, details)),
      ]),
    ]);
  }
}
