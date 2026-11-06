import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/roles/role_constants.dart';
import '../../../controllers/users/admin_request/my_admin_request_controller.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../globals/app_dependencies.dart';
import '../../../utilities/format/formatters.dart';
import '../../../widgets/common/avatars/user_avatar.dart';
import '../../../widgets/common/badges/status_chip.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import 'admin_request_panel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.user;
    if (user == null) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppMessages.profileTitle),
        actions: [IconButton(tooltip: AppMessages.logout, icon: const Icon(Icons.logout), onPressed: auth.logout)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          ConstrainedContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    UserAvatar(userName: user.userName, imageUrl: user.image, radius: Layout.avatarLarge),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.userName, style: theme.textTheme.titleLarge),
                          Text(user.email, style: theme.textTheme.bodyMedium),
                          Text(formatDate(user.createdAt), style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    StatusChip(option: roleOptions[user.role]!),
                  ],
                ),
                const Divider(height: Spacing.xl),
                if (user.isAdmin)
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_outlined),
                    title: const Text(AppMessages.reviewRequests),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AppRoutes.adminRequests),
                  )
                else
                  ChangeNotifierProvider(
                    create: (context) => MyAdminRequestController(context.read<AppDependencies>().adminRequestService)..load(),
                    child: const AdminRequestPanel(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
