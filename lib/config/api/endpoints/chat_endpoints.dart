class ChatEndpoints {
  const ChatEndpoints._();

  static const String unread = '/chat/unread-count';
  static const String conversations = '/chat/conversations';
  static const String groups = '/chat/groups';

  static String conversation(String id) => '$conversations/${Uri.encodeComponent(id)}';
  static String accept(String id) => '${conversation(id)}/accept';
  static String read(String id) => '${conversation(id)}/read';
  static String members(String id) => '${conversation(id)}/members';
  static String member(String id, String userId) => '${members(id)}/${Uri.encodeComponent(userId)}';
  static String messages(String id) => '${conversation(id)}/messages';
  static String message(String id, String messageId) => '${messages(id)}/${Uri.encodeComponent(messageId)}';
  static String reaction(String id, String messageId) => '${message(id, messageId)}/reaction';
}
