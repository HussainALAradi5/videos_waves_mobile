/// Mirrors the server MuteDuration enum.
enum MuteDuration {
  off('off'),
  eightHours('8h'),
  oneWeek('1w'),
  always('always');

  const MuteDuration(this.wire);

  final String wire;
}
