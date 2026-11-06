import 'package:flutter/foundation.dart';

import '../../../enums/users/roles/role.dart';
import '../../../models/users/profile/profile.dart';
import '../../../services/api/api_client.dart';
import '../../../services/users/admin_users/admin_users_service.dart';
import '../../../services/users/social/social_service.dart';

/// One profile with optimistic follow, block, and restrict toggles.
class ProfileController extends ChangeNotifier {
  ProfileController(this._social, this._client, this.userName);

  final SocialService _social;
  final ApiClient _client;
  final String userName;
  Profile? profile;
  Object? error;
  bool isLoading = true;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      profile = await _social.profile(userName);
    } catch (caught) {
      error = caught;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Follow, or for a private account send a request; tapping again unfollows or cancels the request.
  Future<void> toggleFollow() {
    final current = profile!;
    final follow = !(current.isFollowing || current.isRequested);
    final becomesFollower = follow && !current.isPrivate;
    return _optimistic(
      current.copyWith(
        isFollowing: becomesFollower,
        isRequested: follow && current.isPrivate,
        followersCount: current.followersCount + (becomesFollower ? 1 : (current.isFollowing ? -1 : 0)),
      ),
      () => _social.setFollowing(userName, isFollowing: follow),
    );
  }

  /// Accept or decline their request to follow your private account, then refresh.
  Future<void> answerRequest({required bool accept}) async {
    accept ? await _social.acceptRequest(userName) : await _social.declineRequest(userName);
    await load();
  }

  /// Blocking also ends follows both ways, so the profile is reloaded afterwards.
  Future<void> setBlocked(bool isBlocked) async {
    await _social.setBlocked(userName, isBlocked: isBlocked);
    await load();
  }

  /// Admins only; the profile reloads to show the new role.
  Future<void> setRole(Role role) async {
    await AdminUsersService(_client).setRole(userName, role);
    await load();
  }

  /// Admins only; the profile reloads to show the new status.
  Future<void> setActive(bool isActive) async {
    await AdminUsersService(_client).setActive(userName, isActive: isActive);
    await load();
  }

  Future<void> setRestricted(bool isRestricted) =>
      _optimistic(profile!.copyWith(isRestricted: isRestricted), () => _social.setRestricted(userName, isRestricted: isRestricted));

  Future<void> _optimistic(Profile next, Future<void> Function() request) async {
    final previous = profile;
    profile = next;
    notifyListeners();
    try {
      await request();
    } catch (_) {
      profile = previous;
      notifyListeners();
      rethrow;
    }
  }
}
