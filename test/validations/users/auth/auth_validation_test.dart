import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/validations/users/admin_request/admin_request_validation.dart';
import 'package:videos_waves_mobile/validations/users/auth/auth_validation.dart';
import 'package:videos_waves_mobile/validations/videos/video/video_validation.dart';

void main() {
  test('user names follow the server rule', () {
    expect(validateUserName('wave_rider.1'), isNull);
    expect(validateUserName('ab'), isNotNull);
    expect(validateUserName('has space'), isNotNull);
  });

  test('passwords need upper, lower, a digit, and 8+ characters', () {
    expect(validatePassword('Password1'), isNull);
    expect(validatePassword('password1'), isNotNull);
    expect(validatePassword('Short1'), isNotNull);
  });

  test('emails and required fields', () {
    expect(validateEmail('wave@example.com'), isNull);
    expect(validateEmail('not-an-email'), isNotNull);
    expect(validateRequired('  ', 'Title'), 'Title is required.');
  });

  test('video titles, comments, and admin reasons respect limits', () {
    expect(validateVideoTitle(''), isNotNull);
    expect(validateVideoTitle('Sunrise'), isNull);
    expect(isValidComment('   '), isFalse);
    expect(isValidComment('Nice!'), isTrue);
    expect(validateAdminReason('too short'), isNotNull);
    expect(validateAdminReason('I would like to help moderate.'), isNull);
  });
}
