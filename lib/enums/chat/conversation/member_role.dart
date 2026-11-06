/// Group role.
enum MemberRole {
  member('member'),
  admin('admin');

  const MemberRole(this.wire);

  final String wire;

  static MemberRole fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => member);
}
