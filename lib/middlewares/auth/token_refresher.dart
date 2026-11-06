import 'package:dio/dio.dart';

import '../../config/api/endpoints/auth_endpoints.dart';
import '../../constants/common/http_constants.dart';
import '../../models/common/json_map.dart';
import '../../services/storage/token_storage.dart';

/// Outcome of a refresh: new tokens, a rejected session (sign out), or a failure to reach the server.
enum RefreshOutcome { refreshed, rejected, offline }

/// Exchanges the refresh token (the server rotates it). Only a 401 means the session is over; being
/// offline keeps the user signed in.
class TokenRefresher {
  const TokenRefresher(this._plainDio, this._tokenStorage);

  final Dio _plainDio;
  final TokenStorage _tokenStorage;

  Future<(RefreshOutcome, String?)> refresh(String refreshToken) async {
    try {
      final response = await _plainDio.post<JsonMap>(AuthEndpoints.refresh, data: {'refreshToken': refreshToken});
      final tokens = response.data?['data'] as JsonMap;
      final accessToken = tokens['accessToken'] as String;
      await _tokenStorage.save(accessToken: accessToken, refreshToken: tokens['refreshToken'] as String);
      return (RefreshOutcome.refreshed, accessToken);
    } on DioException catch (error) {
      final isRejected = error.response?.statusCode == HttpConstants.unauthorized;
      return (isRejected ? RefreshOutcome.rejected : RefreshOutcome.offline, null);
    }
  }
}
