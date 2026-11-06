import 'dart:async';

import '../../../constants/common/limits_constants.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../enums/users/roles/role.dart';
import '../../../enums/users/user/account_status.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/users/user/user.dart';
import '../../../services/users/admin_users/admin_users_service.dart';
import '../../common/paged_list_controller.dart';

/// Every account for admins, with debounced search and role and status filters.
class AdminUsersController extends PagedListController<User> {
  AdminUsersController(this._service);

  final AdminUsersService _service;
  Timer? _debounce;
  String _search = '';
  Role? role;
  AccountStatus? status;

  @override
  Future<PageResult<User>> fetchPage(int page) => _service.list(
        PageRequestDto(page: page, pageSize: PageSizes.users),
        search: _search,
        role: role,
        status: status,
      );

  void setSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(Timings.searchDebounce, () {
      _search = value.trim();
      loadFirstPage();
    });
  }

  void setRole(Role? next) {
    role = next;
    loadFirstPage();
  }

  void setStatus(AccountStatus? next) {
    status = next;
    loadFirstPage();
  }

  Future<User> setActive(User user, {required bool isActive}) async {
    final updated = await _service.setActive(user.userName, isActive: isActive);
    replaceWhere((item) => item.id == user.id, (_) => updated);
    return updated;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
