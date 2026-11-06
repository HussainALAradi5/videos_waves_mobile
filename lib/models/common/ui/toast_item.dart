import 'package:flutter/foundation.dart';

import '../../../enums/common/toast_type.dart';

/// One queued toast; [actionLabel] with [onAction] adds a button such as Undo or Open.
@immutable
class ToastItem {
  const ToastItem({required this.id, required this.type, required this.message, required this.duration, this.description, this.actionLabel, this.onAction, this.isPausable = true});

  final int id;
  final ToastType type;
  final String message;
  final String? description;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// False for deadlines that must not stretch (unsend Undo): holding the toast then does not pause it.
  final bool isPausable;
}
