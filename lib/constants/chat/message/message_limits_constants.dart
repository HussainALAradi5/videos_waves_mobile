class MessageLimits {
  const MessageLimits._();

  static const int maxAttachments = 10;
  static const int bodyMax = 2000;

  /// Unsend waits this long for Undo before telling the server (as on Instagram).
  static const Duration unsendUndo = Duration(seconds: 5);
  static const Duration editWindow = Duration(minutes: 15);
  static const Duration voiceMax = Duration(minutes: 5);
  static const List<String> reactions = ['❤️', '😂', '😮', '😢', '😡', '👍'];
}
