import '../../../config/api/endpoints/chat_endpoints.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../enums/chat/conversation/inbox_folder.dart';
import '../../../models/chat/conversation/conversation.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../api/api_client.dart';

class ConversationService {
  const ConversationService(this._client);

  final ApiClient _client;

  Future<PageResult<Conversation>> list(InboxFolder folder, PageRequestDto page) =>
      _client.getPage(ChatEndpoints.conversations, {...page.toQuery(), 'folder': folder.wire}, Conversation.fromJson);

  Future<Conversation> get(String id) => _client.get(ChatEndpoints.conversation(id), Conversation.fromJson);

  Future<int> unreadCount() async => (await _client.get(ChatEndpoints.unread, (json) => json['unreadCount'] as int));

  Future<Conversation> startDirect(String userName) =>
      _client.post(ChatEndpoints.conversations, Conversation.fromJson, body: {'userName': userName});

  Future<Conversation> createGroup(String title, List<String> userNames) =>
      _client.post(ChatEndpoints.groups, Conversation.fromJson, body: {'title': title, 'userNames': userNames});

  Future<Conversation> accept(String id) => _client.post(ChatEndpoints.accept(id), Conversation.fromJson);

  Future<void> hide(String id) => _client.delete(ChatEndpoints.conversation(id), ignoreBody);

  Future<void> markRead(String id) => _client.post(ChatEndpoints.read(id), ignoreBody);

  Future<Conversation> setMuted(String id, {required bool isMuted}) =>
      _client.patch(ChatEndpoints.conversation(id), Conversation.fromJson, body: {'isMuted': isMuted});

  Future<void> leave(String id, String myUserId) => _client.delete(ChatEndpoints.member(id, myUserId), ignoreBody);
}
