import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/chat/message/message_limits_constants.dart';
import '../../../enums/chat/conversation/member_status.dart';
import '../../../enums/common/toast_type.dart';
import '../../../enums/chat/message/delete_scope.dart';
import '../../../models/chat/conversation/chat_member.dart';
import '../../../models/chat/conversation/conversation.dart';
import '../../../models/chat/message/message.dart';
import '../../../models/common/json_map.dart';
import '../../../services/chat/conversation/conversation_service.dart';
import '../../../services/chat/message/message_service.dart';
import '../../../services/realtime/socket_service.dart';
import '../../../utilities/errors/api_exception.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../utilities/ui/undo_snackbar_utility.dart';
import 'thread_socket_binding.dart';
import 'typing_tracker.dart';

part 'thread_message_actions.dart';

/// One open chat: messages newest first, live events, sending, and the message actions.
class ThreadController extends ChangeNotifier {
  ThreadController({
    required this._conversations,
    required this._messages,
    required SocketService socket,
    required this.conversationId,
    required this.myUserId,
  }) {
    _binding = ThreadSocketBinding(socket, conversationId, this)..attach();
    _typing = TypingTracker(socket, conversationId, notifyListeners);
  }

  final ConversationService _conversations;
  final MessageService _messages;
  final String conversationId;
  final String myUserId;
  late final ThreadSocketBinding _binding;
  late final TypingTracker _typing;
  final List<Message> _items = [];
  String? _cursor;

  Conversation? conversation;
  Object? error;
  bool isLoading = true;
  bool isLoadingMore = false;
  Message? replyTo;

  List<Message> get messages => List.unmodifiable(_items);
  bool get hasMore => _cursor != null;
  Set<String> get typingUserIds => _typing.userIds;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      conversation = await _conversations.get(conversationId);
      final page = await _messages.list(conversationId);
      _items
        ..clear()
        ..addAll(page.items);
      _cursor = page.nextCursor;
      unawaited(markRead());
    } catch (caught) {
      error = caught;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOlder() async {
    if (isLoadingMore || _cursor == null) return;
    isLoadingMore = true;
    notifyListeners();
    try {
      final page = await _messages.list(conversationId, before: _cursor);
      _items.addAll(page.items.where((item) => !_items.any((known) => known.id == item.id)));
      _cursor = page.nextCursor;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> markRead() async {
    if (conversation?.myStatus == MemberStatus.request) return;
    try {
      await _conversations.markRead(conversationId);
    } catch (_) {
      // Read receipts are best effort.
    }
  }

  Future<void> accept() async {
    conversation = await _conversations.accept(conversationId);
    notifyListeners();
  }

  void setReplyTo(Message? message) {
    replyTo = message;
    notifyListeners();
  }

  /// Sent while the composer has text; stops after a short idle.
  void setTyping(bool isTyping) => _typing.setMine(isTyping);

  // ---- live updates, called by ThreadSocketBinding ----

  void upsert(Message message) {
    final index = _items.indexWhere((item) => item.id == message.id);
    index < 0 ? _items.insert(0, message) : _items[index] = message;
    _typing.clear(message.sender.id);
    notifyListeners();
  }

  void removeMessage(String messageId) {
    _items.removeWhere((item) => item.id == messageId);
    notifyListeners();
  }

  void replace(Message message) {
    final index = _items.indexWhere((item) => item.id == message.id);
    if (index < 0) return;
    _items[index] = message;
    notifyListeners();
  }

  void applyTyping(String userId, bool isTyping) {
    if (userId != myUserId) _typing.setOther(userId, isTyping);
  }

  /// Applies a member change (read time, presence) from a live event.
  void updateMember(String userId, ChatMember Function(ChatMember member) update) {
    final current = conversation;
    if (current == null) return;
    conversation = current.copyWith(members: [
      for (final member in current.members) member.user.id == userId ? update(member) : member,
    ]);
    notifyListeners();
  }

  @override
  void dispose() {
    _typing.dispose();
    _binding.detach();
    super.dispose();
  }
}
