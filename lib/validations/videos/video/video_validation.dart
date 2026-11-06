import '../../../constants/common/limits_constants.dart';

String? validateVideoTitle(String? value) {
  final title = value?.trim() ?? '';
  if (title.isEmpty) return 'Title is required.';
  if (title.length > TextLimits.videoTitleMax) return 'Use at most ${TextLimits.videoTitleMax} characters.';
  return null;
}

bool isValidComment(String value) {
  final content = value.trim();
  return content.isNotEmpty && content.length <= TextLimits.commentMax;
}
