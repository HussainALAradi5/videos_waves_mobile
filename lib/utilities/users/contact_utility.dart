final RegExp _phone = RegExp(r'^\+[1-9]\d{7,14}$');
final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

/// `+973 3300-1122` and `00973...` become `+97333001122` (the server stores E.164).
String normalizePhone(String value) {
  final compact = value.replaceAll(RegExp(r'[\s\-().]'), '');
  return compact.startsWith('00') ? '+${compact.substring(2)}' : compact;
}

bool isPhone(String value) => _phone.hasMatch(normalizePhone(value));

/// People search only runs for a full email or phone number; the server matches them exactly.
bool isContactQuery(String value) => _email.hasMatch(value.trim()) || isPhone(value);
