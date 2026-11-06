enum AccountStatus {
  active('active'),
  inactive('inactive');

  const AccountStatus(this.wire);

  final String wire;
}
