/// Picks the standard avatar until a profile photo is uploaded.
enum Gender {
  male('male'),
  female('female');

  const Gender(this.wire);

  final String wire;

  static Gender fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => male);
}
