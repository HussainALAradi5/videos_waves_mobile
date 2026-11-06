import 'package:flutter/material.dart';

import '../../../constants/common/ui_constants.dart';
import '../../../models/common/ui/status_option.dart';

/// Shows any enum value with the label and color from its option map.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.option});

  final StatusOption option;

  static const double _backgroundAlpha = 0.15;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: option.color.withValues(alpha: _backgroundAlpha),
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Text(
        option.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: option.color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
