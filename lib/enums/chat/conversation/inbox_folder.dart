/// Inbox filters.
enum InboxFolder {
  inbox('inbox'),
  requests('requests'),
  groups('groups'),
  unread('unread'),
  read('read');

  const InboxFolder(this.wire);

  final String wire;

  static InboxFolder fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => inbox);
}
