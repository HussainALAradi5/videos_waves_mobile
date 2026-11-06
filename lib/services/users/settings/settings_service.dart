import '../../../config/api/endpoints/user_endpoints.dart';
import '../../../models/common/json_map.dart';
import '../../../models/users/settings/user_settings.dart';
import '../../../models/users/user/user.dart';
import '../../api/api_client.dart';

/// Settings by key, the avatar, and the profile fields of the signed-in user.
class SettingsService {
  const SettingsService(this._client);

  final ApiClient _client;

  Future<UserSettings> get() => _client.get(UserEndpoints.meSettings, UserSettings.fromJson);

  Future<UserSettings> update(JsonMap changes) => _client.patch(UserEndpoints.meSettings, UserSettings.fromJson, body: changes);

  /// `null` removes the photo (the standard avatar is shown instead).
  Future<User> updateAvatar(String? mediaId) => _client.patch(UserEndpoints.meAvatar, User.fromJson, body: {'mediaId': mediaId});

  Future<User> updateProfile(JsonMap changes) => _client.patch(UserEndpoints.me, User.fromJson, body: changes);
}
