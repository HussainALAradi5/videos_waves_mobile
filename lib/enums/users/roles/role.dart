enum Role {
  admin('admin'),
  user('user');

  const Role(this.wireValue);

  final String wireValue;

  static Role fromWire(String value) =>
      Role.values.firstWhere((role) => role.wireValue == value, orElse: () => Role.user);
}
