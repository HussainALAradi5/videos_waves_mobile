import 'package:dio/dio.dart';

import '../../constants/common/http_constants.dart';
import '../../services/storage/token_storage.dart';
import 'token_refresher.dart';

/// Attaches the access token. On a 401 it refreshes once and retries the request.
/// Queued, so parallel 401s wait for a single refresh instead of racing.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._plainDio, this._tokenStorage, this._onSessionExpired) : _refresher = TokenRefresher(_plainDio, _tokenStorage);

  static const String _hasRetriedKey = 'hasRetried';

  /// A client without this interceptor, so refresh and retry can never loop.
  final Dio _plainDio;
  final TokenStorage _tokenStorage;
  final TokenRefresher _refresher;
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

    final (outcome, accessToken) = await _refresher.refresh(refreshToken);
    if (outcome == RefreshOutcome.rejected) {
      await _tokenStorage.clear();
      _onSessionExpired();
    }
    if (accessToken == null) return handler.next(err);

    final retry = err.requestOptions
      ..extra[_hasRetriedKey] = true
      ..headers[HttpConstants.authorizationHeader] = '${HttpConstants.bearerPrefix}$accessToken';
    try {
      handler.resolve(await _plainDio.fetch<dynamic>(retry));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
