/// The status you choose; invisible shows you offline (mirrors the server).
enum PresenceMode {
  online('online'),
  away('away'),
  busy('busy'),
  invisible('invisible');

  const PresenceMode(this.wire);

  final String wire;

  static PresenceMode fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => online);
}
