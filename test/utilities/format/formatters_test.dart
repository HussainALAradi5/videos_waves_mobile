import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/utilities/format/formatters.dart';

void main() {
  test('relative dates', () {
    final now = DateTime(2026, 11, 6, 12);
    expect(formatRelative(now.subtract(const Duration(seconds: 20)), now: now), 'just now');
    expect(formatRelative(now.subtract(const Duration(minutes: 5)), now: now), '5m ago');
    expect(formatRelative(now.subtract(const Duration(hours: 3)), now: now), '3h ago');
    expect(formatRelative(now.subtract(const Duration(days: 2)), now: now), '2d ago');
  });

  test('compact counts', () {
    expect(formatCount(950), '950');
    expect(formatCount(1500), '1.5K');
  });
}
