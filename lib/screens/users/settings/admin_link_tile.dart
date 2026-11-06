import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/users/admin_users/admin_users_constants.dart';

class AdminLinkTile extends StatelessWidget {
  const AdminLinkTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.manage_accounts_outlined),
        title: const Text(AdminUsersMessages.manage),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(AppRoutes.adminUsers),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.admin_panel_settings_outlined),
        title: const Text(AppMessages.reviewRequests),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(AppRoutes.adminRequests),
      ),
    ]);
  }
}
