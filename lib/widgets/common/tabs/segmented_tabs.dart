import 'package:flutter/material.dart';

import '../../../models/common/ui/dropdown_option.dart';

/// Pill tabs with an animated selection (feed scope, inbox folders, settings sections).
class SegmentedTabs<T> extends StatelessWidget {
  const SegmentedTabs({super.key, required this.options, required this.value, required this.onChanged});

  final List<DropdownOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: [for (final option in options) ButtonSegment(value: option.value, label: Text(option.label), icon: option.leading)],
      selected: {value},
      showSelectedIcon: false,
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
