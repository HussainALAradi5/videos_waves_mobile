/// "1:05" for a duration in seconds.
String formatDuration(double? seconds) {
  if (seconds == null) return '';
  final total = seconds.round();
  final minutes = total ~/ 60;
  return '$minutes:${(total % 60).toString().padLeft(2, '0')}';
}

String formatClockDuration(Duration value) => formatDuration(value.inSeconds.toDouble());

/// "512 B", "1.5 KB", "25 MB".
String formatFileSize(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB'];
  var size = bytes.toDouble();
  var unit = 0;
  while (size >= 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }
  final text = unit == 0 || size >= 10 ? size.round().toString() : size.toStringAsFixed(1);
  return '$text ${units[unit]}';
}
