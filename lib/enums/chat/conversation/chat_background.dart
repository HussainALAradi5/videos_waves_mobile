/// Your own wallpaper for one chat (mirrors the server).
enum ChatBackground {
  none('none'),
  waves('waves'),
  ocean('ocean'),
  mint('mint'),
  sand('sand'),
  blush('blush'),
  night('night'),
  dots('dots');

  const ChatBackground(this.wire);

  final String wire;

  static ChatBackground fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => none);
}
