import 'package:flutter/foundation.dart';

import '../../../models/users/profile/profile.dart';
import '../../../services/users/social/social_service.dart';

/// One profile with optimistic follow, block, and restrict toggles.
class ProfileController extends ChangeNotifier {
  ProfileController(this._social, this.userName);

  final SocialService _social;
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

  Future<void> toggleFollow() {
    final current = profile!;
    final next = !current.isFollowing;
    return _optimistic(
      current.copyWith(isFollowing: next, followersCount: current.followersCount + (next ? 1 : -1)),
      () => _social.setFollowing(userName, isFollowing: next),
    );
  }

  /// Blocking also ends follows both ways, so the profile is reloaded afterwards.
  Future<void> setBlocked(bool isBlocked) async {
    await _social.setBlocked(userName, isBlocked: isBlocked);
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
