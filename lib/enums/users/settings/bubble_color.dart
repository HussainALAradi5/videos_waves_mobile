/// The colour of your own chat bubbles.
enum BubbleColor {
  wave('wave'),
  ocean('ocean'),
  sunset('sunset'),
  forest('forest'),
  mono('mono');

  const BubbleColor(this.wire);

  final String wire;

  static BubbleColor fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => wave);
}
