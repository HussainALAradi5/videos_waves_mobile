import 'package:dio/dio.dart';

import '../../utilities/errors/api_exception.dart';

/// Attaches an [ApiException] to every failed request so callers handle one error type.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: ApiException.fromDio(err)));
  }
}
