import '../../constants/common/page_sizes_constants.dart';
import '../../dtos/common/pagination/page_request_dto.dart';
import '../../enums/notifications/notification_filter.dart';
import '../../models/common/pagination/page_result.dart';
import '../../models/notifications/app_notification.dart';
import '../../services/notifications/notification_service.dart';
import '../common/paged_list_controller.dart';

/// The bell's list, page by page, for all or only unread notifications.
class NotificationListController extends PagedListController<AppNotification> {
  NotificationListController(this._service);

  final NotificationService _service;
  NotificationFilter filter = NotificationFilter.all;

  @override
  Future<PageResult<AppNotification>> fetchPage(int page) => _service.list(filter, PageRequestDto(page: page, pageSize: PageSizes.users));

  void setFilter(NotificationFilter next) {
    if (next == filter) return;
    filter = next;
    loadFirstPage();
  }

  Future<void> markRead(AppNotification notification) async {
    if (notification.isRead) return;
    replaceWhere((item) => item.id == notification.id, (item) => item.markedRead());
    await _service.markRead(notification.id);
  }

  Future<void> markAllRead() async {
    await _service.markAllRead();
    await loadFirstPage();
  }
}
