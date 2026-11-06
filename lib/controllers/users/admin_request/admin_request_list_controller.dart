import '../../../constants/common/limits_constants.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../enums/users/admin_request/admin_request_status.dart';
import '../../../interfaces/services/users/admin_request/admin_request_service_interface.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/users/admin_request/admin_request.dart';
import '../../common/paged_list_controller.dart';

/// Admins review pending requests; a decided request leaves the list.
class AdminRequestListController extends PagedListController<AdminRequest> {
  AdminRequestListController(this._service);

  final AdminRequestServiceInterface _service;
  String? decidingId;

  @override
  Future<PageResult<AdminRequest>> fetchPage(int page) => _service.list(
        PageRequestDto(page: page, pageSize: PageSizes.adminRequests),
        status: AdminRequestStatus.pending,
      );

  Future<void> decide(AdminRequest request, AdminRequestStatus status) async {
    decidingId = request.id;
    notifyListeners();
    try {
      await _service.decide(request.id, status);
      removeWhere((item) => item.id == request.id);
    } finally {
      decidingId = null;
      notifyListeners();
    }
  }
}
