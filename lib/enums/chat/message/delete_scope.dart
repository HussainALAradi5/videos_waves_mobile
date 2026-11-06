/// Delete for me, or unsend for everyone.
enum DeleteScope {
  me('me'),
  everyone('everyone');

  const DeleteScope(this.wire);

  final String wire;

  static DeleteScope fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => me);
}
