import '../../../enums/users/admin_request/admin_request_status.dart';
import '../../base/base_model.dart';
import '../../common/json_map.dart';
import '../user/public_user.dart';

class AdminRequest with BaseModel {
  const AdminRequest({
    required this.id,
    required this.code,
    required this.reason,
    required this.status,
    required this.requester,
    required this.createdAt,
    this.decisionNote,
  });

  factory AdminRequest.fromJson(JsonMap json) => AdminRequest(
        id: json['id'] as String,
        code: json['code'] as String,
        reason: json['reason'] as String,
        status: AdminRequestStatus.fromWire(json['status'] as String),
        requester: PublicUser.fromJson(json['requester'] as JsonMap),
        decisionNote: json['decisionNote'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  final String id;
  @override
  final String code;
  final String reason;
  final AdminRequestStatus status;
  final PublicUser requester;
  final String? decisionNote;
  @override
  final DateTime createdAt;

  bool get isPending => status == AdminRequestStatus.pending;
}
