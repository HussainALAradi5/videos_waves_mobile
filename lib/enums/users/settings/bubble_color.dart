/// The colour of chat bubbles (yours and, separately, theirs).
enum BubbleColor {
  wave('wave'),
  ocean('ocean'),
  sunset('sunset'),
  forest('forest'),
  mono('mono'),
  neutral('neutral');

  const BubbleColor(this.wire);

  final String wire;

  static BubbleColor fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => wave);
}
