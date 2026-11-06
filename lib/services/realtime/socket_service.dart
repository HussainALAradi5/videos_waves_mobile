import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../config/api/api_config.dart';
import '../../constants/chat/realtime/chat_events_constants.dart';
import '../storage/token_storage.dart';

typedef SocketListener = void Function(dynamic payload);

/// One shared socket. Each (re)connect reads the current access token, so it survives refreshes.
class SocketService {
  SocketService(this._tokenStorage);

  final TokenStorage _tokenStorage;
  io.Socket? _socket;
  final Map<String, List<SocketListener>> _listeners = {};

  Future<void> connect() async {
    if (_socket != null) return;
    final token = await _tokenStorage.readAccessToken();
    if (token == null) return;
    final socket = io.io(
      ApiConfig.baseUrl,
      io.OptionBuilder().setTransports(['websocket']).setPath(ChatEvents.socketPath).setAuth({'token': token}).disableAutoConnect().build(),
    );
    socket.onReconnectAttempt((_) async => socket.auth = {'token': await _tokenStorage.readAccessToken()});
    for (final entry in _listeners.entries) {
      for (final listener in entry.value) {
        socket.on(entry.key, listener);
      }
    }
    _socket = socket..connect();
  }

  void on(String event, SocketListener listener) {
    _listeners.putIfAbsent(event, () => []).add(listener);
    _socket?.on(event, listener);
  }

  void off(String event, SocketListener listener) {
    _listeners[event]?.remove(listener);
    _socket?.off(event, listener);
  }

  void emit(String event, Object payload) => _socket?.emit(event, payload);

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }
}
