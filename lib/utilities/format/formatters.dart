import 'package:intl/intl.dart';

final NumberFormat _compact = NumberFormat.compact();
final DateFormat _date = DateFormat.yMMMd();

String formatCount(int value) => _compact.format(value);

String formatDate(DateTime value) => _date.format(value.toLocal());

/// "just now", "5m ago", "3h ago", "2d ago", then a calendar date.
String formatRelative(DateTime value, {DateTime? now}) {
  final elapsed = (now ?? DateTime.now()).difference(value);
  if (elapsed.inMinutes < 1) return 'just now';
  if (elapsed.inHours < 1) return '${elapsed.inMinutes}m ago';
  if (elapsed.inDays < 1) return '${elapsed.inHours}h ago';
  if (elapsed.inDays < 7) return '${elapsed.inDays}d ago';
  return formatDate(value);
}
