import 'package:flutter/foundation.dart';

import '../../../dtos/media/media/picked_file_dto.dart';
import '../../../enums/media/media/media_kind.dart';
import '../../../services/media/media/media_upload_service.dart';
import '../../../services/users/settings/settings_service.dart';
import '../auth/auth_controller.dart';

/// Profile picture and bio changes; the cached account updates when each one succeeds.
class AccountController extends ChangeNotifier {
  AccountController(this._settings, this._uploads, this._auth);

  final SettingsService _settings;
  final MediaUploadService _uploads;
  final AuthController _auth;
  bool isSaving = false;
  double avatarProgress = 0;

  Future<void> changeAvatar(PickedFileDto file) => _run(() async {
        final media = await _uploads.upload(file, MediaKind.avatar, onProgress: (value) {
          avatarProgress = value;
          notifyListeners();
        });
        _auth.updateUser(await _settings.updateAvatar(media.id));
      });

  /// Back to the standard picture for the user's gender.
  Future<void> removeAvatar() => _run(() async => _auth.updateUser(await _settings.updateAvatar(null)));

  /// An empty phone removes the number.
  Future<void> updateDetails({required String bio, required String phone}) => _run(() async => _auth.updateUser(
        await _settings.updateProfile({'bio': bio.trim(), 'phone': phone.trim().isEmpty ? null : phone.trim()}),
      ));

  Future<void> _run(Future<void> Function() action) async {
    isSaving = true;
    avatarProgress = 0;
    notifyListeners();
    try {
      await action();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
