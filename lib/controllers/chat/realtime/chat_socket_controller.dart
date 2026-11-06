import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../constants/chat/realtime/chat_events_constants.dart';
import '../../../constants/common/timings_constants.dart';
import '../../../services/chat/conversation/conversation_service.dart';
import '../../../services/realtime/socket_service.dart';
import '../../users/auth/auth_controller.dart';

/// Keeps the socket connected while signed in and the Messages badge up to date.
class ChatSocketController extends ChangeNotifier {
  ChatSocketController(this._auth, this._socket, this._conversations) {
    _auth.addListener(_sync);
    for (final event in _badgeEvents) {
      _socket.on(event, _onActivity);
    }
    _sync();
  }

  static const List<String> _badgeEvents = [ChatEvents.messageNew, ChatEvents.conversationUpdated, ChatEvents.conversationRead];

  final AuthController _auth;
  final SocketService _socket;
  final ConversationService _conversations;
  String? _connectedFor;
  Timer? _debounce;
  int unreadCount = 0;

  Future<void> refreshUnread() async {
    try {
      unreadCount = await _conversations.unreadCount();
      notifyListeners();
    } catch (_) {
      // The badge is best effort; the next event retries.
    }
  }

  Future<void> _sync() async {
    final userId = _auth.isAuthenticated ? _auth.user?.id : null;
    if (userId == _connectedFor) return;
    _socket.disconnect();
    _connectedFor = userId;
    unreadCount = 0;
    notifyListeners();
    if (userId == null) return;
    // The HTTP call refreshes an expired access token before the socket handshake reads it.
    await refreshUnread();
    if (_connectedFor == userId) await _socket.connect();
  }

  void _onActivity(dynamic _) {
    _debounce?.cancel();
    _debounce = Timer(Timings.refreshDebounce, refreshUnread);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _auth.removeListener(_sync);
    for (final event in _badgeEvents) {
      _socket.off(event, _onActivity);
    }
    super.dispose();
  }
}
