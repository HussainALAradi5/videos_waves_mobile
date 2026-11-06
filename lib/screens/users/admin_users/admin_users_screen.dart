import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/admin_users/admin_users_constants.dart';
import '../../../constants/users/roles/role_constants.dart';
import '../../../controllers/users/admin_users/admin_users_controller.dart';
import '../../../enums/users/roles/role.dart';
import '../../../enums/users/user/account_status.dart';
import '../../../globals/app_dependencies.dart';
import '../../../models/common/ui/dropdown_option.dart';
import '../../../services/users/admin_users/admin_users_service.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/dropdown/app_dropdown.dart';
import '../../../widgets/common/feedback/empty_view.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import '../../../widgets/common/lists/paged_list_view.dart';
import '../../../widgets/users/admin_users/admin_user_tile.dart';

final List<DropdownOption<Role?>> _roles = [
  const DropdownOption(value: null, label: AdminUsersMessages.allRoles),
  for (final role in Role.values) DropdownOption(value: role, label: roleOptions[role]!.label),
];

final List<DropdownOption<AccountStatus?>> _statuses = [
  const DropdownOption(value: null, label: AdminUsersMessages.allStatuses),
  for (final status in AccountStatus.values) DropdownOption(value: status, label: accountStatusOptions[status]!.label),
];

/// Admins only (the route guard sends everyone else away).
class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late final AdminUsersController _users = AdminUsersController(AdminUsersService(context.read<AppDependencies>().apiClient))
    ..loadFirstPage();

  @override
  void dispose() {
    _users.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AdminUsersMessages.title)),
      body: ConstrainedContent(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.md, Spacing.sm, Spacing.md, 0),
            child: TextField(
              onChanged: _users.setSearch,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: AdminUsersMessages.search, isDense: true),
            ),
          ),
          ListenableBuilder(
            listenable: _users,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
              child: Row(children: [
                AppDropdown<Role?>(options: _roles, value: _users.role, onChanged: _users.setRole),
                const SizedBox(width: Spacing.sm),
                AppDropdown<AccountStatus?>(options: _statuses, value: _users.status, onChanged: _users.setStatus),
                const Spacer(),
                Text('${_users.totalItems}', style: Theme.of(context).textTheme.labelLarge),
              ]),
            ),
          ),
          Expanded(
            child: PagedListView(
              controller: _users,
              empty: const EmptyView(title: AdminUsersMessages.empty, icon: Icons.people_outline),
              itemBuilder: (context, user) => AdminUserTile(
                user: user,
                onSetActive: (isActive) => runWithFeedback(
                  context,
                  () => _users.setActive(user, isActive: isActive),
                  successMessage: isActive ? AdminUsersMessages.activated(user.userName) : AdminUsersMessages.deactivated(user.userName),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.sm),
            child: Text(AdminUsersMessages.exportHint, style: Theme.of(context).textTheme.bodySmall),
          ),
        ]),
      ),
    );
  }
}
