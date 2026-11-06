import 'package:flutter/material.dart';

import '../../../constants/users/settings/bubble_gradients_constants.dart';
import '../../../enums/users/settings/bubble_color.dart';
import '../../../models/common/ui/dropdown_option.dart';

/// Round colour samples; the chosen one grows and gets a ring.
class BubbleSwatches extends StatelessWidget {
  const BubbleSwatches({super.key, required this.options, required this.value, required this.onChanged});

  final List<DropdownOption<String>> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final ring = Theme.of(context).colorScheme.primary;
    return Wrap(spacing: 10, runSpacing: 8, children: [
      for (final option in options)
        Semantics(
          label: option.label,
          selected: option.value == value,
          button: true,
          child: GestureDetector(
            onTap: () => onChanged(option.value),
            child: AnimatedScale(
              scale: option.value == value ? 1.12 : 1,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: BubbleGradients.of(BubbleColor.fromWire(option.value)),
                  border: Border.all(color: option.value == value ? ring : Colors.transparent, width: 2.5),
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
