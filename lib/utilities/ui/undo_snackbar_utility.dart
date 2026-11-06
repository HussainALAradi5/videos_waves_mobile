import 'package:flutter/material.dart';

import '../../constants/common/motion_constants.dart';

const String _undoLabel = 'Undo';

/// "Comment deleted - Undo": the action restores what was just removed.
/// Takes the messenger, not a context: the deleted row is gone by the time this runs.
void showUndoSnackBar(ScaffoldMessengerState messenger, String message, VoidCallback onUndo) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      duration: Motion.undo,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(label: _undoLabel, onPressed: onUndo),
    ));
}
