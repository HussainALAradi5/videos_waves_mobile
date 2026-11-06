/// What others see of someone's status (mirrors the server).
enum PresenceState {
  online('online'),
  away('away'),
  busy('busy'),
  offline('offline');

  const PresenceState(this.wire);

  final String wire;

  static PresenceState? fromWire(String? value) => value == null ? null : values.firstWhere((item) => item.wire == value, orElse: () => offline);
}
