import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/chat/realtime/chat_events_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/notifications/notification_constants.dart';
import '../../../constants/common/timings_constants.dart';
import '../../../enums/common/toast_type.dart';
import '../../../models/chat/message/message.dart';
import '../../../models/notifications/app_notification.dart';
import '../../../services/chat/conversation/conversation_service.dart';
import '../../../services/notifications/notification_service.dart';
import '../../../services/realtime/socket_service.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../users/auth/auth_controller.dart';
import '../../users/settings/settings_controller.dart';

/// Keeps the socket connected while signed in, the Messages and bell badges up to date, and shows live pop-ups.
class ChatSocketController extends ChangeNotifier {
  ChatSocketController(this._auth, this._socket, this._conversations, this._notifications, this._settings) {
    _auth.addListener(_sync);
    for (final event in _badgeEvents) {
      _socket.on(event, _onActivity);
    }
    _socket.on(ChatEvents.notificationNew, _onNotification);
    _socket.on(ChatEvents.messageNew, _onMessage);
    _sync();
  }

  static const List<String> _badgeEvents = [ChatEvents.messageNew, ChatEvents.conversationUpdated, ChatEvents.conversationRead];

  final AuthController _auth;
  final SocketService _socket;
  final ConversationService _conversations;
  final NotificationService _notifications;
  final SettingsController _settings;
  String? _connectedFor;
  Timer? _debounce;
  int unreadCount = 0;
  int notificationCount = 0;

  /// Set by the app: opens an in-app path (toast "Open"), and reads the path on screen.
  void Function(String path)? openPath;
  String Function()? currentPath;

  Future<void> refreshNotifications() async {
    try {
      notificationCount = await _notifications.unreadCount();
      notifyListeners();
    } catch (_) {
      // Best effort, like the chat badge.
    }
  }

  void _onNotification(dynamic payload) {
    if (payload is! Map) return;
    refreshNotifications();
    final notification = AppNotification.fromJson(Map<String, dynamic>.from(payload));
    showToast(ToastType.info, notification.message, actionLabel: NotificationMessages.open, onAction: () => openPath?.call(notification.link));
  }

  /// A pop-up for a message in a chat you do not have open (never yours, system notices, or muted chats).
  Future<void> _onMessage(dynamic payload) async {
    if (payload is! Map || !(_settings.settings?.notifyMessages ?? true)) return;
    final message = Message.fromJson(Map<String, dynamic>.from(payload));
    final path = AppRoutes.thread(message.conversationId);
    if (message.sender.id == _auth.user?.id || message.isSystem || currentPath?.call() == path) return;
    try {
      if ((await _conversations.get(message.conversationId)).isMuted) return;
    } catch (_) {
      return;
    }
    showToast(
      ToastType.info,
      ChatMessages.newMessageFrom(message.sender.userName),
      description: message.body ?? ChatMessages.attachmentPreview,
      actionLabel: NotificationMessages.open,
      onAction: () => openPath?.call(path),
    );
  }

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
    notificationCount = 0;
    notifyListeners();
    if (userId == null) return;
    // The HTTP call refreshes an expired access token before the socket handshake reads it.
    await refreshUnread();
    await refreshNotifications();
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
    _socket.off(ChatEvents.notificationNew, _onNotification);
    _socket.off(ChatEvents.messageNew, _onMessage);
    super.dispose();
  }
}
