import '../../../constants/common/app_colors_constants.dart';
import '../../../enums/users/user/account_status.dart';
import '../../../models/common/ui/status_option.dart';

const Map<AccountStatus, StatusOption> accountStatusOptions = {
  AccountStatus.active: StatusOption(label: 'Active', color: AppColors.accepted),
  AccountStatus.inactive: StatusOption(label: 'Inactive', color: AppColors.rejected),
};

class AdminUsersMessages {
  const AdminUsersMessages._();

  static const String title = 'Users';
  static const String manage = 'Manage users';
  static const String search = 'Search by username or email';
  static const String allRoles = 'All roles';
  static const String allStatuses = 'All statuses';
  static const String empty = 'No accounts match these filters.';
  static const String deactivate = 'Deactivate';
  static const String activate = 'Activate';
  static const String makeAdmin = 'Make admin';
  static const String removeAdmin = 'Remove admin';
  static String roleChanged(String userName, {required bool isAdmin}) =>
      '$userName is now ${isAdmin ? 'an admin' : 'a regular user'}. They were signed out to apply it.';
  static const String confirmBody =
      'They are signed out everywhere and cannot sign in. Their profile, videos, and comments are hidden until you activate them again. Nothing is deleted.';
  static const String exportHint = 'Export and import CSV are on the web admin page.';
  static String confirmTitle(String userName) => 'Deactivate $userName?';
  static String deactivated(String userName) => '$userName was deactivated. Their videos and comments are hidden.';
  static String activated(String userName) => '$userName is active again.';
}
