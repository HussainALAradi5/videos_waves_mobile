import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/settings/setting_sections_constants.dart';
import '../../../constants/users/settings/settings_messages_constants.dart';
import '../../../controllers/users/admin_request/my_admin_request_controller.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../controllers/users/settings/settings_controller.dart';
import '../../../globals/app_dependencies.dart';
import '../../../widgets/common/feedback/loading_view.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import '../profile/admin_request_panel.dart';
import 'account_section.dart';
import 'admin_link_tile.dart';
import 'setting_row_tile.dart';

/// Account, preference sections from the settings table, admin access, and sign out.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final settings = context.watch<SettingsController>();
    final values = settings.settings?.toJson();
    final heading = Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary);
    return Scaffold(
      appBar: AppBar(title: const Text(SettingsMessages.title)),
      body: ConstrainedContent(
        child: ListView(padding: const EdgeInsets.all(Spacing.md), children: [
          Text(SettingsMessages.account, style: heading),
          const AccountSection(),
          if (values == null)
            const LoadingView()
          else
            for (final section in settingSections) ...[
              const SizedBox(height: Spacing.lg),
              Text(section.title, style: heading),
              for (final row in section.rows) SettingRowTile(row: row, value: values[row.key], onChanged: (value) => settings.change({row.key: value})),
            ],
          const SizedBox(height: Spacing.lg),
          Text(SettingsMessages.admin, style: heading),
          if (auth.isAdmin)
            const AdminLinkTile()
          else
            ChangeNotifierProvider(
              create: (context) => MyAdminRequestController(context.read<AppDependencies>().adminRequestService)..load(),
              child: const AdminRequestPanel(),
            ),
          const SizedBox(height: Spacing.lg),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
            title: Text(AppMessages.logout, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onTap: auth.logout,
          ),
        ]),
      ),
    );
  }
}
