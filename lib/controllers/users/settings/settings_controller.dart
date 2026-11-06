import 'package:flutter/material.dart';

import '../../../controllers/users/auth/auth_controller.dart';
import '../../../enums/users/settings/theme_preference.dart';
import '../../../models/common/json_map.dart';
import '../../../models/users/settings/user_settings.dart';
import '../../../services/storage/preferences_storage.dart';
import '../../../services/users/settings/settings_service.dart';

/// The signed-in user's settings: loaded on sign-in, changed optimistically, rolled back on failure.
class SettingsController extends ChangeNotifier {
  SettingsController(this._service, this._auth, this._preferences) {
    _auth.addListener(_sync);
    _loadDeviceTheme();
    _sync();
  }

  final SettingsService _service;
  final AuthController _auth;
  final PreferencesStorage _preferences;
  UserSettings? settings;
  String? _loadedFor;

  /// Used while signed out (and remembered from the last account), so guests can switch themes too.
  ThemePreference _deviceTheme = ThemePreference.system;

  ThemePreference get themePreference => settings?.theme ?? _deviceTheme;

  ThemeMode get themeMode => switch (themePreference) {
        ThemePreference.light => ThemeMode.light,
        ThemePreference.dark => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  /// The sun / moon button: flips to the opposite of what is shown now.
  Future<void> toggleTheme(Brightness shown) async {
    final next = shown == Brightness.dark ? ThemePreference.light : ThemePreference.dark;
    _deviceTheme = next;
    await _preferences.saveTheme(next.wire);
    if (settings == null) {
      notifyListeners();
      return;
    }
    await change({'theme': next.wire});
  }

  Future<void> _loadDeviceTheme() async {
    _deviceTheme = ThemePreference.fromWire(await _preferences.readTheme());
    if (settings == null) notifyListeners();
  }

  Future<void> change(JsonMap changes) async {
    final previous = settings;
    if (previous == null) return;
    settings = previous.apply(changes);
    notifyListeners();
    try {
      settings = await _service.update(changes);
    } catch (_) {
      settings = previous;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _sync() async {
    final userId = _auth.user?.id;
    if (userId == _loadedFor) return;
    _loadedFor = userId;
    settings = null;
    notifyListeners();
    if (userId == null) return;
    try {
      final loaded = await _service.get();
      if (_loadedFor == userId) settings = loaded;
    } catch (_) {
      _loadedFor = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _auth.removeListener(_sync);
    super.dispose();
  }
}
