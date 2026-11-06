/// What an upload is for; each kind has its own size and type rules.
enum MediaKind {
  video('video'),
  avatar('avatar'),
  chatAttachment('chat_attachment'),
  voiceNote('voice_note');

  const MediaKind(this.wire);

  final String wire;

  static MediaKind fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => video);
}
