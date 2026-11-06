class AppRoutes {
  const AppRoutes._();

  static const String feed = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String search = '/search';
  static const String upload = '/upload';
  static const String messages = '/messages';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String adminRequests = '/admin/requests';
  static const String adminUsers = '/admin/users';
  static const String adminPrefix = '/admin';
  static const String videoPattern = '/videos/:videoId';
  static const String userPattern = '/u/:userName';
  static const String threadPattern = '/messages/:conversationId';
  static const String videoIdParam = 'videoId';
  static const String userNameParam = 'userName';
  static const String conversationIdParam = 'conversationId';
  static const String redirectParam = 'redirect';

  static String video(String videoId) => '/videos/${Uri.encodeComponent(videoId)}';
  static String user(String userName) => '/u/${Uri.encodeComponent(userName)}';
  static String thread(String conversationId) => '$messages/${Uri.encodeComponent(conversationId)}';

  /// Routes that need a signed-in user.
  static const List<String> protectedPrefixes = [upload, messages, profile, settings, notifications, adminPrefix];
}
