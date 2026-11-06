class AppRoutes {
  const AppRoutes._();

  static const String feed = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String upload = '/upload';
  static const String profile = '/profile';
  static const String adminRequests = '/admin/requests';
  static const String videoPattern = '/videos/:videoId';
  static const String videoIdParam = 'videoId';
  static const String redirectParam = 'redirect';

  static String video(String videoId) => '/videos/${Uri.encodeComponent(videoId)}';

  /// Routes that need a signed-in user.
  static const List<String> protectedPrefixes = [upload, profile, adminRequests];
}
