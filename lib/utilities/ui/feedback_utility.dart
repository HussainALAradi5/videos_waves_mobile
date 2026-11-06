import 'package:flutter/material.dart';

import '../../enums/common/toast_type.dart';
import '../../globals/app_toasts.dart';
import '../errors/api_exception.dart';

/// Shows a toast of any type (works without a context, for socket events too).
void showToast(ToastType type, String message,
    {String? description, Duration? duration, String? actionLabel, VoidCallback? onAction, bool isPausable = true}) {
  appToasts.show(type, message, description: description, duration: duration, actionLabel: actionLabel, onAction: onAction, isPausable: isPausable);
}

/// A neutral confirmation, such as "Copied".
void showMessage(BuildContext context, String message) => showToast(ToastType.info, message);

/// Runs an action and reports the outcome as a toast. Returns true on success.
Future<bool> runWithFeedback(BuildContext context, Future<void> Function() action, {String? successMessage}) async {
  try {
    await action();
    if (successMessage != null) showToast(ToastType.success, successMessage);
    return true;
  } catch (error) {
    showToast(ToastType.error, errorMessageOf(error));
    return false;
  }
}
