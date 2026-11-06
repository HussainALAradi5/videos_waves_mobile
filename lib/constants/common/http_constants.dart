/// Platform-neutral HTTP values (`dart:io` is unavailable on the web build).
class HttpConstants {
  const HttpConstants._();

  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const int unauthorized = 401;
}
