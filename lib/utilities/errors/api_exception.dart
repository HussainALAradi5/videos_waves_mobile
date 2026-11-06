import 'package:dio/dio.dart';

import '../../constants/common/messages_constants.dart';
import '../../enums/common/error_code.dart';
import '../../models/common/json_map.dart';

/// The one error type every service throws, built from the server error envelope.
class ApiException implements Exception {
  const ApiException({required this.status, required this.code, required this.message});

  factory ApiException.fromDio(DioException error) {
    final response = error.response;
    if (response == null) {
      return const ApiException(status: 0, code: ErrorCode.network, message: AppMessages.networkError);
    }
    final data = response.data;
    final body = data is JsonMap ? data['error'] : null;
    if (body is JsonMap) {
      return ApiException(
        status: response.statusCode ?? 0,
        code: ErrorCode.fromWire(body['code'] as String?),
        message: body['message'] as String? ?? AppMessages.unexpectedError,
      );
    }
    return ApiException(
      status: response.statusCode ?? 0,
      code: ErrorCode.internal,
      message: AppMessages.unexpectedError,
    );
  }

  final int status;
  final ErrorCode code;
  final String message;

  bool get isNotFound => code == ErrorCode.notFound;

  @override
  String toString() => message;
}

/// A readable message for any error shown to the user.
String errorMessageOf(Object error) => error is ApiException ? error.message : AppMessages.unexpectedError;
