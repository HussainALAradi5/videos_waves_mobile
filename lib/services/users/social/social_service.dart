import '../../../config/api/endpoints/user_endpoints.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../models/common/json_map.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/users/profile/profile.dart';
import '../../../models/users/profile/user_summary.dart';
import '../../api/api_client.dart';

/// Profiles, people search, follows, blocks, and restrictions.
class SocialService {
  const SocialService(this._client);

  final ApiClient _client;

  Future<Profile> profile(String userName) => _client.get(UserEndpoints.profile(userName), Profile.fromJson);

  Future<PageResult<UserSummary>> search(String search, PageRequestDto page) => _client.getPage(
        UserEndpoints.search,
        {...page.toQuery(), if (search.isNotEmpty) 'search': search},
        UserSummary.fromJson,
      );

  Future<PageResult<UserSummary>> followers(String userName, PageRequestDto page) =>
      _client.getPage(UserEndpoints.followers(userName), page.toQuery(), UserSummary.fromJson);

  Future<PageResult<UserSummary>> following(String userName, PageRequestDto page) =>
      _client.getPage(UserEndpoints.following(userName), page.toQuery(), UserSummary.fromJson);

  Future<JsonMap> setFollowing(String userName, {required bool isFollowing}) =>
      isFollowing ? _client.put(UserEndpoints.follow(userName), ignoreBody) : _client.delete(UserEndpoints.follow(userName), ignoreBody);

  Future<JsonMap> setBlocked(String userName, {required bool isBlocked}) =>
      isBlocked ? _client.put(UserEndpoints.block(userName), ignoreBody) : _client.delete(UserEndpoints.block(userName), ignoreBody);

  Future<JsonMap> setRestricted(String userName, {required bool isRestricted}) => isRestricted
      ? _client.put(UserEndpoints.restrict(userName), ignoreBody)
      : _client.delete(UserEndpoints.restrict(userName), ignoreBody);
}
