import '../../../config/api/endpoints/admin_request_endpoints.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../enums/users/admin_request/admin_request_status.dart';
import '../../../interfaces/services/users/admin_request/admin_request_service_interface.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/users/admin_request/admin_request.dart';
import '../../api/api_client.dart';

class AdminRequestService implements AdminRequestServiceInterface {
  const AdminRequestService(this._client);

  final ApiClient _client;

  @override
  Future<PageResult<AdminRequest>> list(PageRequestDto page, {AdminRequestStatus? status}) => _client.getPage(
        AdminRequestEndpoints.root,
        {...page.toQuery(), if (status != null) 'status': status.wireValue},
        AdminRequest.fromJson,
      );

  @override
  Future<AdminRequest> create(String reason) =>
      _client.post(AdminRequestEndpoints.root, AdminRequest.fromJson, body: {'reason': reason});

  @override
  Future<AdminRequest> cancel(String requestId) =>
      _client.delete(AdminRequestEndpoints.byId(requestId), AdminRequest.fromJson);

  @override
  Future<AdminRequest> decide(String requestId, AdminRequestStatus status) => _client.patch(
        AdminRequestEndpoints.decision(requestId),
        AdminRequest.fromJson,
        body: {'status': status.wireValue},
      );
}
