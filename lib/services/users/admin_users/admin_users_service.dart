import '../../../config/api/endpoints/user_endpoints.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../enums/users/roles/role.dart';
import '../../../enums/users/user/account_status.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/users/user/user.dart';
import '../../api/api_client.dart';

/// Admin-only account management (export and import live on the web admin page).
class AdminUsersService {
  const AdminUsersService(this._client);

  final ApiClient _client;

  Future<PageResult<User>> list(PageRequestDto page, {String search = '', Role? role, AccountStatus? status}) => _client.getPage(
        UserEndpoints.root,
        {
          ...page.toQuery(),
          if (search.isNotEmpty) 'search': search,
          'role': ?role?.wireValue,
          'status': ?status?.wire,
        },
        User.fromJson,
      );

  Future<User> setActive(String userName, {required bool isActive}) =>
      _client.patch(UserEndpoints.status(userName), User.fromJson, body: {'isActive': isActive});

  /// Admins only, never your own account; the person is signed out so the new role applies.
  Future<User> setRole(String userName, Role role) => _client.patch(UserEndpoints.role(userName), User.fromJson, body: {'role': role.wireValue});
}
