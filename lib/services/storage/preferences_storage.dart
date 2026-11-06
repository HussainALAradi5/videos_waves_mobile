import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/common/storage_keys_constants.dart';

/// Device-only preferences that must work before sign-in (the theme).
class PreferencesStorage {
  PreferencesStorage({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> readTheme() => _storage.read(key: StorageKeys.theme);

  Future<void> saveTheme(String wire) => _storage.write(key: StorageKeys.theme, value: wire);
}
