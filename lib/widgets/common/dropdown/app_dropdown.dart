import 'package:flutter/material.dart';

import '../../../constants/common/motion_constants.dart';
import '../../../constants/common/radii_constants.dart';
import '../../../models/common/ui/dropdown_option.dart';
import '../badges/status_chip.dart';

/// A custom dropdown: a pill trigger and a menu that scales and fades in under it.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({super.key, required this.options, required this.value, required this.onChanged});

  final List<DropdownOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = options.firstWhere((option) => option.value == value, orElse: () => options.first);
    return PopupMenuButton<T>(
      initialValue: value,
      onSelected: onChanged,
      position: PopupMenuPosition.under,
      popUpAnimationStyle: const AnimationStyle(duration: Motion.quick, reverseDuration: Motion.quick),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.lg)),
      itemBuilder: (_) => [
        for (final option in options)
          PopupMenuItem<T>(
            value: option.value,
            child: Row(children: [
              if (option.leading != null) ...[option.leading!, const SizedBox(width: 10)],
              Expanded(child: option.badge == null ? Text(option.label) : Align(alignment: Alignment.centerLeft, child: StatusChip(option: option.badge!))),
              if (option.value == value) Icon(Icons.check, size: 18, color: scheme.primary),
            ]),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(Radii.pill)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (selected.badge == null) Text(selected.label, style: const TextStyle(fontWeight: FontWeight.w600)) else StatusChip(option: selected.badge!),
          const SizedBox(width: 4),
          const Icon(Icons.expand_more, size: 18),
        ]),
      ),
    );
  }
}
