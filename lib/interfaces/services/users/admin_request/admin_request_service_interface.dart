import '../../../../dtos/common/pagination/page_request_dto.dart';
import '../../../../enums/users/admin_request/admin_request_status.dart';
import '../../../../models/common/pagination/page_result.dart';
import '../../../../models/users/admin_request/admin_request.dart';

abstract interface class AdminRequestServiceInterface {
  Future<PageResult<AdminRequest>> list(PageRequestDto page, {AdminRequestStatus? status});
  Future<AdminRequest> create(String reason);
  Future<AdminRequest> cancel(String requestId);
  Future<AdminRequest> decide(String requestId, AdminRequestStatus status);
}
