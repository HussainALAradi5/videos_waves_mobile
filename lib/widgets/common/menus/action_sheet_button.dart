import 'package:flutter/material.dart';

import '../../../constants/common/spacing_constants.dart';
import '../../../models/common/ui/action_item.dart';

/// The three-dots button: opens a bottom sheet with the actions (destructive ones last, in red).
class ActionSheetButton extends StatelessWidget {
  const ActionSheetButton({super.key, required this.items, required this.tooltip});

  final List<ActionItem> items;
  final String tooltip;

  Future<void> _open(BuildContext context) async {
    final regular = items.where((item) => !item.isDanger);
    final danger = items.where((item) => item.isDanger);
    final chosen = await showModalBottomSheet<ActionItem>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final errorColor = Theme.of(sheetContext).colorScheme.error;
        Widget tile(ActionItem item) => ListTile(
              leading: Icon(item.icon, color: item.isDanger ? errorColor : null),
              title: Text(item.label, style: TextStyle(color: item.isDanger ? errorColor : null)),
              onTap: () => Navigator.of(sheetContext).pop(item),
            );
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Spacing.sm),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ...regular.map(tile),
              if (regular.isNotEmpty && danger.isNotEmpty) const Divider(),
              ...danger.map(tile),
            ]),
          ),
        );
      },
    );
    chosen?.onSelected();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return IconButton(tooltip: tooltip, icon: const Icon(Icons.more_horiz), onPressed: () => _open(context));
  }
}
