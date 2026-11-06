import '../../../enums/users/roles/role.dart';
import '../../../models/common/ui/status_option.dart';
import '../../common/ui_constants.dart';

const Map<Role, StatusOption> roleOptions = {
  Role.admin: StatusOption(label: 'Admin', color: AppColors.admin),
  Role.user: StatusOption(label: 'Member', color: AppColors.seed),
};
