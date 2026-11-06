import 'package:dio/dio.dart';

import '../../config/api/endpoints/auth_endpoints.dart';
import '../../constants/common/http_constants.dart';
import '../../models/common/json_map.dart';
import '../../services/storage/token_storage.dart';

/// Attaches the access token. On a 401 it refreshes once and retries the request.
/// Queued, so parallel 401s wait for a single refresh instead of racing.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._plainDio, this._tokenStorage, this._onSessionExpired);

  static const String _hasRetriedKey = 'hasRetried';

  /// A client without this interceptor, so refresh and retry can never loop.
  final Dio _plainDio;
  final TokenStorage _tokenStorage;
  final void Function() _onSessionExpired;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken != null) options.headers[HttpConstants.authorizationHeader] = '${HttpConstants.bearerPrefix}$accessToken';
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == HttpConstants.unauthorized;
    final hasRetried = err.requestOptions.extra[_hasRetriedKey] == true;
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (!isUnauthorized || hasRetried || refreshToken == null) return handler.next(err);

    final accessToken = await _refresh(refreshToken);
    if (accessToken == null) {
      await _tokenStorage.clear();
      _onSessionExpired();
      return handler.next(err);
    }

    final retry = err.requestOptions
      ..extra[_hasRetriedKey] = true
      ..headers[HttpConstants.authorizationHeader] = '${HttpConstants.bearerPrefix}$accessToken';
    try {
      handler.resolve(await _plainDio.fetch<dynamic>(retry));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String?> _refresh(String refreshToken) async {
    try {
      final response = await _plainDio.post<JsonMap>(AuthEndpoints.refresh, data: {'refreshToken': refreshToken});
      final tokens = response.data?['data'] as JsonMap;
      final accessToken = tokens['accessToken'] as String;
      await _tokenStorage.save(accessToken: accessToken, refreshToken: tokens['refreshToken'] as String);
      return accessToken;
    } on DioException {
      return null;
    }
  }
}
