import 'package:flutter/material.dart';

import '../errors/api_exception.dart';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
}

/// Runs an action and reports the outcome in a snack bar. Returns true on success.
Future<bool> runWithFeedback(BuildContext context, Future<void> Function() action, {String? successMessage}) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await action();
    if (successMessage != null) {
      messenger.showSnackBar(SnackBar(content: Text(successMessage), behavior: SnackBarBehavior.floating));
    }
    return true;
  } catch (error) {
    messenger.showSnackBar(SnackBar(content: Text(errorMessageOf(error)), behavior: SnackBarBehavior.floating));
    return false;
  }
}
