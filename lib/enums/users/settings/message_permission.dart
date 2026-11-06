/// Who may start a chat with you.
enum MessagePermission {
  everyone('everyone'),
  following('following');

  const MessagePermission(this.wire);

  final String wire;

  static MessagePermission fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => everyone);
}
