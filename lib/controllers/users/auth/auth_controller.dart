import 'package:flutter/foundation.dart';

import '../../../constants/common/http_constants.dart';
import '../../../dtos/users/auth/auth_session_dto.dart';
import '../../../dtos/users/auth/login_request_dto.dart';
import '../../../dtos/users/auth/register_request_dto.dart';
import '../../../enums/common/auth_status.dart';
import '../../../interfaces/services/users/auth/auth_service_interface.dart';
import '../../../models/users/user/user.dart';
import '../../../services/storage/token_storage.dart';
import '../../../utilities/errors/api_exception.dart';

/// Owns the signed-in state; the router listens to it to guard protected screens.
class AuthController extends ChangeNotifier {
  AuthController(this._authService, this._tokenStorage);

  final AuthServiceInterface _authService;
  final TokenStorage _tokenStorage;

  AuthStatus status = AuthStatus.unknown;
  User? user;
  bool isSubmitting = false;
  bool hasSessionExpired = false;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isAdmin => user?.isAdmin ?? false;

  /// Restores a stored session on app start. Only a rejected session clears the tokens;
  /// being offline keeps them so the next start can sign back in.
  Future<void> restore() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null) return _setGuest();
    try {
      user = await _authService.me();
      status = AuthStatus.authenticated;
      notifyListeners();
    } on ApiException catch (error) {
      if (error.status == HttpConstants.unauthorized) await _tokenStorage.clear();
      _setGuest();
    } catch (_) {
      _setGuest();
    }
  }

  Future<void> login(LoginRequestDto dto) => _signIn(() => _authService.login(dto));

  Future<void> register(RegisterRequestDto dto) => _signIn(() => _authService.register(dto));

  /// Signs out this device only; other devices keep their sessions.
  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (_) {
      // Local sign-out always succeeds, even when the server call fails.
    }
    await _tokenStorage.clear();
    _setGuest();
  }

  /// Keeps the cached account in step after a profile or avatar change.
  void updateUser(User next) {
    user = next;
    notifyListeners();
  }

  /// Called by the HTTP client when a refresh is rejected.
  void handleSessionExpired() {
    if (!isAuthenticated) return;
    hasSessionExpired = true;
    _setGuest();
  }

  void consumeSessionExpired() => hasSessionExpired = false;

  Future<void> _signIn(Future<AuthSessionDto> Function() request) async {
    isSubmitting = true;
    notifyListeners();
    try {
      final session = await request();
      await _tokenStorage.save(accessToken: session.accessToken, refreshToken: session.refreshToken);
      user = session.user;
      status = AuthStatus.authenticated;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void _setGuest() {
    user = null;
    status = AuthStatus.guest;
    notifyListeners();
  }
}
