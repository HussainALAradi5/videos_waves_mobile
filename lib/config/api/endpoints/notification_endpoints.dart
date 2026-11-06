/// Mirrors ROUTES.NOTIFICATIONS on the server.
class NotificationEndpoints {
  const NotificationEndpoints._();

  static const String root = '/notifications';
  static const String unreadCount = '/notifications/unread-count';
  static const String readAll = '/notifications/read-all';

  static String read(String id) => '/notifications/${Uri.encodeComponent(id)}/read';
}
