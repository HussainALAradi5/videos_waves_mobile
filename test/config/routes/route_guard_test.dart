import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/config/routes/route_guard.dart';
import 'package:videos_waves_mobile/constants/common/routes_constants.dart';

void main() {
  test('only in-app paths are accepted as redirects', () {
    expect(safeRedirect('/profile'), '/profile');
    expect(safeRedirect('//evil.example.com'), AppRoutes.feed);
    expect(safeRedirect('https://evil.example.com'), AppRoutes.feed);
    expect(safeRedirect(null), AppRoutes.feed);
  });
}
