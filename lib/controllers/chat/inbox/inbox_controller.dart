import 'dart:async';

import '../../../constants/chat/realtime/chat_events_constants.dart';
import '../../../constants/common/limits_constants.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../enums/chat/conversation/inbox_folder.dart';
import '../../../models/chat/conversation/conversation.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../services/chat/conversation/conversation_service.dart';
import '../../../services/realtime/socket_service.dart';
import '../../common/paged_list_controller.dart';

/// The chat list for one folder; reloads quietly when a live event changes it.
class InboxController extends PagedListController<Conversation> {
  InboxController(this._conversations, this._socket) {
    for (final event in _events) {
      _socket.on(event, _onActivity);
    }
  }

  static const List<String> _events = [ChatEvents.messageNew, ChatEvents.conversationUpdated];

  final ConversationService _conversations;
  final SocketService _socket;
  Timer? _debounce;
  InboxFolder folder = InboxFolder.inbox;

  @override
  Future<PageResult<Conversation>> fetchPage(int page) =>
      _conversations.list(folder, PageRequestDto(page: page, pageSize: PageSizes.conversations));

  void setFolder(InboxFolder next) {
    if (next == folder) return;
    folder = next;
    loadFirstPage();
  }

  Future<void> hide(Conversation conversation) async {
    await _conversations.hide(conversation.id);
    removeWhere((item) => item.id == conversation.id);
  }

  void markReadLocally(String conversationId) =>
      replaceWhere((item) => item.id == conversationId, (item) => item.copyWith(unreadCount: 0));

  void _onActivity(dynamic _) {
    _debounce?.cancel();
    _debounce = Timer(Timings.refreshDebounce, loadFirstPage);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final event in _events) {
      _socket.off(event, _onActivity);
    }
    super.dispose();
  }
}
