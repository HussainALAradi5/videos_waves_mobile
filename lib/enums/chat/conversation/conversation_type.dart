/// One-to-one or group chat.
enum ConversationType {
  direct('direct'),
  group('group');

  const ConversationType(this.wire);

  final String wire;

  static ConversationType fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => direct);
}
