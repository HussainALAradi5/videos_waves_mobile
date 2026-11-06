/// Shape of chat bubbles (mirrors the server).
enum BubbleStyle {
  rounded('rounded'),
  square('square'),
  minimal('minimal');

  const BubbleStyle(this.wire);

  final String wire;

  static BubbleStyle fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => rounded);
}
