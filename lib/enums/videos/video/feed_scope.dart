/// Everyone you may see, only people you follow, or public accounts to discover.
enum FeedScope {
  all('all'),
  following('following'),

  /// Public accounts only, never your own (like Instagram Explore).
  discover('discover');

  const FeedScope(this.wire);

  final String wire;

  static FeedScope fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => all);
}
