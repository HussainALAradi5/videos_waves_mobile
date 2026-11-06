import '../../../config/api/endpoints/chat_endpoints.dart';
import '../../../enums/chat/message/delete_scope.dart';
import '../../../models/chat/message/message.dart';
import '../../../models/common/json_map.dart';
import '../../../models/common/pagination/cursor_page.dart';
import '../../api/api_client.dart';

class MessageService {
  const MessageService(this._client);

  static const int pageSize = 30;

  final ApiClient _client;

  Future<CursorPage<Message>> list(String conversationId, {String? before}) => _client.getCursorPage(
        ChatEndpoints.messages(conversationId),
        {'pageSize': pageSize, 'before': ?before},
        Message.fromJson,
      );

  Future<Message> send(String conversationId, JsonMap body) =>
      _client.post(ChatEndpoints.messages(conversationId), Message.fromJson, body: body);

  Future<Message> edit(String conversationId, String messageId, String body) =>
      _client.patch(ChatEndpoints.message(conversationId, messageId), Message.fromJson, body: {'body': body});

  Future<void> remove(String conversationId, String messageId, DeleteScope scope) =>
      _client.delete(ChatEndpoints.message(conversationId, messageId), ignoreBody, query: {'scope': scope.wire});

  Future<Message> react(String conversationId, String messageId, String emoji) =>
      _client.put(ChatEndpoints.reaction(conversationId, messageId), Message.fromJson, body: {'emoji': emoji});

  Future<Message> unreact(String conversationId, String messageId) =>
      _client.delete(ChatEndpoints.reaction(conversationId, messageId), Message.fromJson);
}
