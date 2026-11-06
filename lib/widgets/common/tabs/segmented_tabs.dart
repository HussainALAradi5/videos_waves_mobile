import 'package:flutter/material.dart';

import '../../../constants/common/gradients_constants.dart';
import '../../../models/common/ui/dropdown_option.dart';

/// Full-width pill tabs: a soft track with a brand-gradient thumb that slides to the chosen tab
/// (feed scope, inbox filters, notifications, sign-up).
class SegmentedTabs<T> extends StatelessWidget {
  const SegmentedTabs({super.key, required this.options, required this.value, required this.onChanged});

  static const Duration _slide = Duration(milliseconds: 320);
  static const double _height = 44;

  final List<DropdownOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final count = options.length;
    final index = options.indexWhere((option) => option.value == value).clamp(0, count - 1);
    final x = count == 1 ? 0.0 : -1 + 2 * index / (count - 1);
    return Container(
      height: _height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(_height),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Stack(children: [
        AnimatedAlign(
          duration: _slide,
          curve: Curves.easeOutCubic,
          alignment: Alignment(x, 0),
          child: FractionallySizedBox(
            widthFactor: 1 / count,
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppGradients.brand,
                borderRadius: BorderRadius.circular(_height),
                boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Row(children: [
            for (final option in options)
              Expanded(child: _Segment(label: option.label, leading: option.leading, isSelected: option.value == value, onTap: () => onChanged(option.value))),
          ]),
        ),
      ]),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.isSelected, required this.onTap, this.leading});

  final String label;
  final Widget? leading;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: AnimatedDefaultTextStyle(
          duration: SegmentedTabs._slide,
          style: TextStyle(color: color, fontSize: 13, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500),
          child: IconTheme.merge(
            data: IconThemeData(color: color, size: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (leading != null) ...[leading!, const SizedBox(width: 6)],
              Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ]),
          ),
        ),
      ),
    );
  }
}
