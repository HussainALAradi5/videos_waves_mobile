import '../../../enums/chat/realtime/presence_state.dart';
import '../../../constants/chat/realtime/chat_events_constants.dart';
import '../../../models/chat/message/message.dart';
import '../../../models/chat/message/reaction_count.dart';
import '../../../models/common/json_map.dart';
import '../../../services/realtime/socket_service.dart';
import 'thread_controller.dart';

/// Routes socket events for one conversation into its ThreadController.
class ThreadSocketBinding {
  ThreadSocketBinding(this._socket, this._conversationId, this._thread);

  final SocketService _socket;
  final String _conversationId;
  final ThreadController _thread;
  late final Map<String, SocketListener> _handlers = {
    ChatEvents.messageNew: (payload) => _forThread(payload, (json) {
          final message = Message.fromJson(json);
          _thread.upsert(message);
          if (message.sender.id != _thread.myUserId) _thread.markRead();
        }),
    ChatEvents.messageUpdated: (payload) => _forThread(payload, (json) => _thread.replace(Message.fromJson(json))),
    ChatEvents.messageReaction: (payload) => _forThread(payload, _applyReaction),
    ChatEvents.conversationRead: (payload) => _forThread(payload, (json) {
          final readAt = json['lastReadAt'] as String?;
          if (readAt != null) _thread.updateMember(json['userId'] as String, (member) => member.copyWith(lastReadAt: DateTime.parse(readAt)));
        }),
    ChatEvents.typing: (payload) => _forThread(payload, (json) => _thread.applyTyping(json['userId'] as String, json['isTyping'] as bool)),
    ChatEvents.presence: (payload) {
      if (payload is! JsonMap) return;
      final isOnline = payload['isOnline'] as bool;
      // A null presence means it is hidden from us, so it stays hidden.
      _thread.updateMember(
        payload['userId'] as String,
        (member) => member.isOnline == null
            ? member
            : member.copyWith(isOnline: isOnline, presence: PresenceState.fromWire(payload['presence'] as String?), statusText: payload['statusText'] as String? ?? ''),
      );
    },
  };

  void attach() => _handlers.forEach(_socket.on);

  void detach() => _handlers.forEach(_socket.off);

  void _applyReaction(JsonMap json) {
    final messageId = json['messageId'] as String;
    final index = _thread.messages.indexWhere((item) => item.id == messageId);
    if (index < 0) return;
    final emoji = json['emoji'] as String?;
    final isMine = json['userId'] == _thread.myUserId;
    final reactions = (json['reactions'] as List<dynamic>).cast<JsonMap>().map(ReactionCount.fromJson).toList();
    _thread.replace(_thread.messages[index].copyWith(reactions: reactions, myReaction: isMine ? emoji : null, clearMyReaction: isMine && emoji == null));
  }

  void _forThread(dynamic payload, void Function(JsonMap json) apply) {
    if (payload is JsonMap && payload['conversationId'] == _conversationId) apply(payload);
  }
}
