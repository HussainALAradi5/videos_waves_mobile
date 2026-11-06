/// Everyone, or only people you follow.
enum FeedScope {
  all('all'),
  following('following');

  const FeedScope(this.wire);

  final String wire;

  static FeedScope fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => all);
}
