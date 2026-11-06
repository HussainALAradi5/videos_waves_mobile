class ChatOptionsMessages {
  const ChatOptionsMessages._();

  static const String menu = 'Chat options';
  static const String mute = 'Mute';
  static const String for8h = 'For 8 hours';
  static const String for1w = 'For 1 week';
  static const String untilUnmute = 'Until I unmute';
  static const String unmute = 'Unmute';
  static const String muted = 'Muted. No sound or unread badge from this chat.';
  static const String unmuted = 'Chat unmuted.';
  static const String deleteChat = 'Delete chat';
  static const String leaveGroup = 'Leave group';
  static const String deleteBody =
      'It goes from your list only; the others keep it. If someone writes again, the chat comes back with the new message.';
  static const String leaveBody = 'You stop getting its messages and cannot write in it. You can still read what was sent before you left.';
  static const String deleted = 'Chat deleted from your list.';
  static String deleteTitle(String title) => 'Delete "$title" from your chats?';
  static String leaveTitle(String title) => 'Leave "$title"?';
  static String left(String title) => 'You left "$title".';
}
