/// App theme, saved to the account.
enum ThemePreference {
  system('system'),
  light('light'),
  dark('dark');

  const ThemePreference(this.wire);

  final String wire;

  static ThemePreference fromWire(String? value) => values.firstWhere((item) => item.wire == value, orElse: () => system);
}
