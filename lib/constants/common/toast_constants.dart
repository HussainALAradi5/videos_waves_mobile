import 'package:flutter/material.dart';

import '../../enums/common/toast_type.dart';
import 'app_colors_constants.dart';

/// Icon and accent colour per toast type, and the queue limits.
class ToastLooks {
  const ToastLooks._();

  static const Map<ToastType, ({IconData icon, Color color})> byType = {
    ToastType.success: (icon: Icons.check_circle_rounded, color: AppColors.accepted),
    ToastType.error: (icon: Icons.error_rounded, color: AppColors.danger),
    ToastType.warning: (icon: Icons.warning_amber_rounded, color: AppColors.pending),
    ToastType.info: (icon: Icons.info_rounded, color: AppColors.brandStart),
  };

  /// At most this many show at once; the rest wait their turn.
  static const int maxVisible = 3;

  /// Older toasts beyond this are dropped so a burst never piles up.
  static const int maxQueued = 10;
  static const Duration defaultDuration = Duration(milliseconds: 3500);
  static const Duration enter = Duration(milliseconds: 280);
  static const String dismiss = 'Dismiss';
}
