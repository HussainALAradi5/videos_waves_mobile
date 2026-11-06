import 'package:flutter/material.dart';

import '../../constants/common/motion_constants.dart';
import '../../enums/common/toast_type.dart';
import 'feedback_utility.dart';

const String _undoLabel = 'Undo';

/// "Comment deleted - Undo": the action restores what was just removed.
void showUndoToast(String message, VoidCallback onUndo, {Duration duration = Motion.undo, bool isPausable = true}) =>
    showToast(ToastType.info, message, duration: duration, actionLabel: _undoLabel, onAction: onUndo, isPausable: isPausable);
