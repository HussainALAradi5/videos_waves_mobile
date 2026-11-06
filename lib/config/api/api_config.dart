/// API connection settings.
///
/// Set the server origin at build time:
/// `flutter run --dart-define=API_BASE_URL=http://192.168.1.20:5000`.
/// The default reaches the host machine from the Android emulator.
/// Release builds must use an HTTPS origin.
class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 10);
}
