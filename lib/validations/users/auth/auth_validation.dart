import '../../../utilities/users/contact_utility.dart';
// Mirrors the server user rules for instant feedback; the server stays authoritative.

final RegExp _userNamePattern = RegExp(r'^[a-zA-Z0-9_.]{3,30}$');
final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
final RegExp _passwordPattern = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,72}$');

String? validateRequired(String? value, String label) =>
    (value == null || value.trim().isEmpty) ? '$label is required.' : null;

String? validateUserName(String? value) => _userNamePattern.hasMatch(value?.trim() ?? '')
    ? null
    : 'Use 3-30 letters, numbers, dots, or underscores.';

/// Optional: empty means no number.
String? validatePhone(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty || isPhone(text)) return null;
  return 'Use your number with its country code, for example +973 3300 1122.';
}

String? validateEmail(String? value) =>
    _emailPattern.hasMatch(value?.trim() ?? '') ? null : 'Enter a valid email address.';

String? validatePassword(String? value) => _passwordPattern.hasMatch(value ?? '')
    ? null
    : 'Use 8+ characters with upper and lower case letters and a number.';
