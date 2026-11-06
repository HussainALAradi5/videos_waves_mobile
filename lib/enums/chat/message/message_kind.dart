/// What a message carries.
enum MessageKind {
  text('text'),
  media('media'),
  voice('voice'),
  videoShare('video_share'),
  system('system');

  const MessageKind(this.wire);

  final String wire;

  static MessageKind fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => text);
}
