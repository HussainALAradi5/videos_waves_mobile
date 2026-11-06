import '../../../constants/common/page_sizes_constants.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/users/profile/user_summary.dart';
import '../../../services/users/social/social_service.dart';
import '../../common/paged_list_controller.dart';

/// People waiting to follow your private account, with Accept and Decline.
class FollowRequestController extends PagedListController<UserSummary> {
  FollowRequestController(this._social);

  final SocialService _social;

  @override
  Future<PageResult<UserSummary>> fetchPage(int page) => _social.followRequests(PageRequestDto(page: page, pageSize: PageSizes.users));

  Future<void> accept(UserSummary person) async {
    await _social.acceptRequest(person.user.userName);
    removeWhere((item) => item.user.id == person.user.id);
  }

  Future<void> decline(UserSummary person) async {
    await _social.declineRequest(person.user.userName);
    removeWhere((item) => item.user.id == person.user.id);
  }
}
