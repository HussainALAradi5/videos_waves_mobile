import 'dart:async';

import '../../../constants/common/limits_constants.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/users/profile/user_summary.dart';
import '../../../services/users/social/social_service.dart';
import '../../common/paged_list_controller.dart';

typedef UserPageFetcher = Future<PageResult<UserSummary>> Function(String search, PageRequestDto page);

/// Any paged list of people (search, followers, following) with inline Follow buttons.
class UserListController extends PagedListController<UserSummary> {
  UserListController(this._social, this._fetch);

  final SocialService _social;
  final UserPageFetcher _fetch;
  Timer? _debounce;
  String _search = '';

  @override
  Future<PageResult<UserSummary>> fetchPage(int page) => _fetch(_search, PageRequestDto(page: page, pageSize: PageSizes.users));

  void setSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(Timings.searchDebounce, () {
      _search = value.trim();
      loadFirstPage();
    });
  }

  /// The server answers with the real state (a private account gives Requested, not Following).
  Future<void> toggleFollow(UserSummary summary) async {
    final follow = !(summary.isFollowing || summary.isRequested);
    bool isSame(UserSummary item) => item.user.id == summary.user.id;
    replaceWhere(isSame, (item) => item.copyWith(isFollowing: follow, isRequested: false));
    try {
      final state = await _social.setFollowing(summary.user.userName, isFollowing: follow);
      replaceWhere(isSame, (item) => item.copyWith(isFollowing: state['isFollowing'] as bool? ?? follow, isRequested: state['isRequested'] as bool? ?? false));
    } catch (_) {
      replaceWhere(isSame, (item) => item.copyWith(isFollowing: summary.isFollowing, isRequested: summary.isRequested));
      rethrow;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
