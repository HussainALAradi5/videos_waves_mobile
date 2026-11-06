import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/admin_users/admin_users_constants.dart';
import '../../../constants/users/roles/role_constants.dart';
import '../../../enums/users/user/account_status.dart';
import '../../../models/users/user/user.dart';
import '../../common/avatars/user_avatar.dart';
import '../../common/badges/status_chip.dart';
import 'account_status_button.dart';

/// One account: avatar, name, email, role and status badges, and the activate or deactivate action.
class AdminUserTile extends StatelessWidget {
  const AdminUserTile({super.key, required this.user, required this.onSetActive});

  final User user;
  final Future<void> Function(bool isActive) onSetActive;

  @override
  Widget build(BuildContext context) {
    final status = user.isActive ? AccountStatus.active : AccountStatus.inactive;
    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(children: [
          Opacity(opacity: user.isActive ? 1 : 0.5, child: UserAvatar(user: user.asPublic, size: 44)),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: InkWell(
              onTap: () => context.push(AppRoutes.user(user.userName)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(user.email, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                const SizedBox(height: Spacing.xs),
                Wrap(spacing: Spacing.xs, children: [
                  StatusChip(option: roleOptions[user.role]!),
                  StatusChip(option: accountStatusOptions[status]!),
                ]),
              ]),
            ),
          ),
          if (!user.isAdmin) AccountStatusButton(userName: user.userName, isActive: user.isActive, onChanged: onSetActive),
        ]),
      ),
    );
  }
}
