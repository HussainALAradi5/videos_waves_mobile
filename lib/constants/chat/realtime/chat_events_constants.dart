/// Socket.IO event names (mirror the server ChatEvent enum).
class ChatEvents {
  const ChatEvents._();

  static const String messageNew = 'message:new';
  static const String messageUpdated = 'message:updated';
  static const String messageReaction = 'message:reaction';
  static const String conversationUpdated = 'conversation:updated';
  static const String conversationRead = 'conversation:read';
  static const String typing = 'typing';
  static const String presence = 'presence';
  static const String socketPath = '/socket.io';
}
