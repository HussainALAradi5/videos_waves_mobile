import '../../../enums/users/admin_request/admin_request_status.dart';
import '../../../models/common/ui/status_option.dart';
import '../../common/ui_constants.dart';

const Map<AdminRequestStatus, StatusOption> adminRequestStatusOptions = {
  AdminRequestStatus.pending: StatusOption(label: 'Pending', color: AppColors.pending),
  AdminRequestStatus.accepted: StatusOption(label: 'Accepted', color: AppColors.accepted),
  AdminRequestStatus.rejected: StatusOption(label: 'Rejected', color: AppColors.rejected),
  AdminRequestStatus.cancelled: StatusOption(label: 'Cancelled', color: AppColors.cancelled),
};
