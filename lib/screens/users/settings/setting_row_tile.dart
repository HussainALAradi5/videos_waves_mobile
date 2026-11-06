import 'package:flutter/material.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../enums/users/settings/setting_control.dart';
import '../../../models/users/settings/setting_row.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/dropdown/app_dropdown.dart';
import '../../../widgets/users/settings/bubble_swatches.dart';

/// One preference: a switch, the custom dropdown, colour swatches, or a short text, saved as soon as it changes.
class SettingRowTile extends StatelessWidget {
  const SettingRowTile({super.key, required this.row, required this.value, required this.onChanged});

  final SettingRow row;
  final Object? value;
  final Future<void> Function(Object value) onChanged;

  Future<void> _editText(BuildContext context) async {
    final text = TextEditingController(text: '${value ?? ''}');
    final next = await showDialog<String>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(row.label),
        content: TextField(controller: text, autofocus: true, maxLength: row.maxLength, decoration: InputDecoration(hintText: row.hint)),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialog).pop(), child: const Text(AppMessages.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialog).pop(text.text.trim()), child: const Text(AppMessages.save)),
        ],
      ),
    ).whenComplete(text.dispose);
    if (next != null && next != value && context.mounted) await runWithFeedback(context, () => onChanged(next));
  }

  @override
  Widget build(BuildContext context) {
    void save(Object next) => runWithFeedback(context, () => onChanged(next));
    final subtitle = Text(row.description, style: Theme.of(context).textTheme.bodySmall);
    switch (row.control) {
      case SettingControl.toggle:
        return SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(row.label), subtitle: subtitle, value: value == true, onChanged: save);
      case SettingControl.swatches:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(row.label, style: Theme.of(context).textTheme.bodyLarge),
            subtitle,
            const SizedBox(height: 10),
            BubbleSwatches(options: row.choices, value: '$value', onChanged: save),
          ]),
        );
      case SettingControl.text:
        final text = '${value ?? ''}';
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(row.label),
          subtitle: Text(text.isEmpty ? row.description : text, style: Theme.of(context).textTheme.bodySmall),
          trailing: const Icon(Icons.edit_outlined),
          onTap: () => _editText(context),
        );
      case SettingControl.choice:
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(row.label),
          subtitle: subtitle,
          trailing: AppDropdown<String>(options: row.choices, value: '$value', onChanged: save),
        );
    }
  }
}
