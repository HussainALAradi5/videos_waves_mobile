/// What a notification is about (mirrors the server).
enum NotificationKind {
  follow('follow'),
  followRequest('follow_request'),
  followAccepted('follow_accepted'),
  like('like'),
  comment('comment'),
  reply('reply'),
  groupAdded('group_added'),
  adminAccepted('admin_accepted'),
  adminRejected('admin_rejected');

  const NotificationKind(this.wire);

  final String wire;

  static NotificationKind fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => follow);
}
