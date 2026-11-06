import 'package:flutter/material.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/admin_request/admin_request_status_constants.dart';
import '../../../models/users/admin_request/admin_request.dart';
import '../../../utilities/format/formatters.dart';
import '../../common/avatars/user_avatar.dart';
import '../../common/badges/status_chip.dart';

class AdminRequestTile extends StatelessWidget {
  const AdminRequestTile({super.key, required this.request, required this.onAccept, required this.onReject, this.isBusy = false});

  final AdminRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(user: request.requester),
                const SizedBox(width: Spacing.sm),
                Expanded(child: Text(request.requester.userName, style: theme.textTheme.titleSmall)),
                StatusChip(option: adminRequestStatusOptions[request.status]!),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Text(request.reason),
            const SizedBox(height: Spacing.xs),
            Text(formatDate(request.createdAt), style: theme.textTheme.bodySmall),
            if (request.isPending)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: isBusy ? null : onReject, child: const Text(AppMessages.reject)),
                  const SizedBox(width: Spacing.sm),
                  FilledButton(onPressed: isBusy ? null : onAccept, child: const Text(AppMessages.accept)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
