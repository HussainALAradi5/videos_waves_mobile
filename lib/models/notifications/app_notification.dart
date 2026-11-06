import '../../enums/notifications/notification_kind.dart';
import '../common/json_map.dart';
import '../users/user/public_user.dart';

/// One entry in the bell; [message] is ready to show and [link] is an in-app path.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.message,
    required this.link,
    required this.isRead,
    required this.createdAt,
    this.actor,
  });

  factory AppNotification.fromJson(JsonMap json) => AppNotification(
        id: json['id'] as String,
        kind: NotificationKind.fromWire(json['kind'] as String?),
        actor: json['actor'] == null ? null : PublicUser.fromJson(json['actor'] as JsonMap),
        message: json['message'] as String,
        link: json['link'] as String,
        isRead: json['isRead'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  final String id;
  final NotificationKind kind;

  /// null for system notifications (admin decisions).
  final PublicUser? actor;
  final String message;
  final String link;
  final bool isRead;
  final DateTime createdAt;

  AppNotification markedRead() =>
      AppNotification(id: id, kind: kind, actor: actor, message: message, link: link, isRead: true, createdAt: createdAt);
}
