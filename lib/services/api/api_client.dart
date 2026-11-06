import 'package:dio/dio.dart';

import '../../config/api/api_config.dart';
import '../../middlewares/auth/auth_interceptor.dart';
import '../../middlewares/errors/error_interceptor.dart';
import '../../models/common/json_map.dart';
import '../../models/common/pagination/page_meta.dart';
import '../../models/common/pagination/page_result.dart';
import '../../utilities/errors/api_exception.dart';
import '../storage/token_storage.dart';

typedef JsonParser<T> = T Function(JsonMap json);

/// The one configured HTTP client. Unwraps the server envelope `{ success, data, meta }`.
class ApiClient {
  ApiClient({required TokenStorage tokenStorage, required void Function() onSessionExpired})
      : _dio = Dio(_options()) {
    _dio.interceptors.addAll([
      AuthInterceptor(Dio(_options()), tokenStorage, onSessionExpired),
      ErrorInterceptor(),
    ]);
  }

  final Dio _dio;

  static BaseOptions _options() => BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
      );

  Future<T> get<T>(String path, JsonParser<T> parse) async =>
      parse(_data(await _send(() => _dio.get<JsonMap>(path))));

  Future<PageResult<T>> getPage<T>(String path, Map<String, Object> query, JsonParser<T> parse) async {
    final body = await _send(() => _dio.get<JsonMap>(path, queryParameters: query));
    final items = (body['data'] as List<dynamic>).cast<JsonMap>().map(parse).toList();
    return PageResult(items: items, meta: PageMeta.fromJson(body['meta'] as JsonMap));
  }

  Future<T> post<T>(String path, JsonParser<T> parse, {Object? body, Options? options, ProgressCallback? onSendProgress}) async =>
      parse(_data(await _send(() => _dio.post<JsonMap>(path, data: body, options: options, onSendProgress: onSendProgress))));

  Future<T> put<T>(String path, JsonParser<T> parse) async => parse(_data(await _send(() => _dio.put<JsonMap>(path))));

  Future<T> patch<T>(String path, JsonParser<T> parse, {Object? body}) async =>
      parse(_data(await _send(() => _dio.patch<JsonMap>(path, data: body))));

  Future<T> delete<T>(String path, JsonParser<T> parse) async =>
      parse(_data(await _send(() => _dio.delete<JsonMap>(path))));

  JsonMap _data(JsonMap body) => body['data'] as JsonMap;

  Future<JsonMap> _send(Future<Response<JsonMap>> Function() request) async {
    try {
      return (await request()).data ?? <String, dynamic>{};
    } on DioException catch (error) {
      final cause = error.error;
      throw cause is ApiException ? cause : ApiException.fromDio(error);
    }
  }
}

/// Parser for endpoints whose payload the caller does not need (for example `{ message }`).
JsonMap ignoreBody(JsonMap json) => json;
