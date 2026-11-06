class MessageLimits {
  const MessageLimits._();

  static const int maxAttachments = 10;
  static const int bodyMax = 2000;
  static const Duration editWindow = Duration(minutes: 15);
  static const Duration voiceMax = Duration(minutes: 5);
  static const List<String> reactions = ['❤️', '😂', '😮', '😢', '😡', '👍'];
}
