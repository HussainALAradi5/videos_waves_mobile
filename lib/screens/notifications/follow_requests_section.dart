import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/notifications/notification_constants.dart';
import '../../controllers/users/social/follow_request_controller.dart';
import '../../enums/common/button_tone.dart';
import '../../utilities/ui/feedback_utility.dart';
import '../../widgets/common/avatars/user_avatar.dart';
import '../../widgets/common/buttons/app_button.dart';

/// Pending follow requests for a private account; hidden when nobody is waiting.
class FollowRequestsSection extends StatelessWidget {
  const FollowRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = context.watch<FollowRequestController>();
    if (requests.items.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${NotificationMessages.requestsTitle} (${requests.totalItems})', style: Theme.of(context).textTheme.titleSmall),
          for (final person in requests.items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: UserAvatar(user: person.user, size: 40),
              title: Text(person.user.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: Wrap(spacing: 6, children: [
                AppButton(
                  label: NotificationMessages.accept,
                  tone: ButtonTone.gradient,
                  onPressed: () => runWithFeedback(context, () => requests.accept(person), successMessage: NotificationMessages.accepted(person.user.userName)),
                ),
                AppButton(
                  label: NotificationMessages.decline,
                  tone: ButtonTone.secondary,
                  onPressed: () => runWithFeedback(context, () => requests.decline(person), successMessage: NotificationMessages.declined),
                ),
              ]),
            ),
        ]),
      ),
    );
  }
}
