/// Mirrors the server ErrorCode enum; [network] is client-only (no response received).
enum ErrorCode {
  validation('VALIDATION_ERROR'),
  unauthorized('UNAUTHORIZED'),
  forbidden('FORBIDDEN'),
  notFound('NOT_FOUND'),
  conflict('CONFLICT'),
  payloadTooLarge('PAYLOAD_TOO_LARGE'),
  unsupportedMediaType('UNSUPPORTED_MEDIA_TYPE'),
  tooManyRequests('TOO_MANY_REQUESTS'),
  internal('INTERNAL_ERROR'),
  network('NETWORK_ERROR');

  const ErrorCode(this.wireValue);

  final String wireValue;

  static ErrorCode fromWire(String? value) =>
      ErrorCode.values.firstWhere((code) => code.wireValue == value, orElse: () => ErrorCode.internal);
}
