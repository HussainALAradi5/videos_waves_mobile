import '../../../constants/common/limits_constants.dart';

String? validateAdminReason(String? value) {
  final reason = value?.trim() ?? '';
  if (reason.length < TextLimits.adminReasonMin) return 'Use at least ${TextLimits.adminReasonMin} characters.';
  if (reason.length > TextLimits.adminReasonMax) return 'Use at most ${TextLimits.adminReasonMax} characters.';
  return null;
}
