import 'dart:async';

import '../../../constants/chat/realtime/chat_events_constants.dart';
import '../../../constants/common/timings_constants.dart';
import '../../../services/realtime/socket_service.dart';

/// Typing state for one chat: sends mine (stopping after an idle pause) and expires others'.
class TypingTracker {
  TypingTracker(this._socket, this._conversationId, this._onChanged);

  final SocketService _socket;
  final String _conversationId;
  final void Function() _onChanged;
  final Map<String, Timer> _others = {};
  Timer? _idle;
  bool _isSent = false;

  Set<String> get userIds => _others.keys.toSet();

  void setMine(bool isTyping) {
    _idle?.cancel();
    if (isTyping) _idle = Timer(Timings.typingIdle, () => setMine(false));
    if (isTyping == _isSent) return;
    _isSent = isTyping;
    _socket.emit(ChatEvents.typing, {'conversationId': _conversationId, 'isTyping': isTyping});
  }

  void setOther(String userId, bool isTyping) {
    _others.remove(userId)?.cancel();
    if (isTyping) _others[userId] = Timer(Timings.typingExpiry, () => setOther(userId, false));
    _onChanged();
  }

  /// A message arrived from them, so they stopped typing.
  void clear(String userId) => _others.remove(userId)?.cancel();

  void dispose() {
    setMine(false);
    _idle?.cancel();
    for (final timer in _others.values) {
      timer.cancel();
    }
  }
}
