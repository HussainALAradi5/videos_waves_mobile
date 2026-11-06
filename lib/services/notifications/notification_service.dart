import '../../config/api/endpoints/notification_endpoints.dart';
import '../../dtos/common/pagination/page_request_dto.dart';
import '../../enums/notifications/notification_filter.dart';
import '../../models/common/pagination/page_result.dart';
import '../../models/notifications/app_notification.dart';
import '../api/api_client.dart';

/// The notification bell: list, unread count, and mark read.
class NotificationService {
  const NotificationService(this._client);

  final ApiClient _client;

  Future<PageResult<AppNotification>> list(NotificationFilter filter, PageRequestDto page) =>
      _client.getPage(NotificationEndpoints.root, {...page.toQuery(), 'filter': filter.wire}, AppNotification.fromJson);

  Future<int> unreadCount() => _client.get(NotificationEndpoints.unreadCount, (json) => json['unreadCount'] as int);

  Future<void> markRead(String id) => _client.patch(NotificationEndpoints.read(id), ignoreBody);

  Future<void> markAllRead() => _client.patch(NotificationEndpoints.readAll, ignoreBody);
}
