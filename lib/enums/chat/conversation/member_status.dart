/// In the inbox, or waiting in message requests.
enum MemberStatus {
  accepted('accepted'),
  request('request');

  const MemberStatus(this.wire);

  final String wire;

  static MemberStatus fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => accepted);
}
