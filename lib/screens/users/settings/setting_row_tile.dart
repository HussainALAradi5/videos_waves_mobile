import 'package:flutter/material.dart';

import '../../../enums/users/settings/setting_control.dart';
import '../../../models/users/settings/setting_row.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/dropdown/app_dropdown.dart';

/// One preference: a switch or the custom dropdown, saved as soon as it changes.
class SettingRowTile extends StatelessWidget {
  const SettingRowTile({super.key, required this.row, required this.value, required this.onChanged});

  final SettingRow row;
  final Object? value;
  final Future<void> Function(Object value) onChanged;

  @override
  Widget build(BuildContext context) {
    void save(Object next) => runWithFeedback(context, () => onChanged(next));
    final subtitle = Text(row.description, style: Theme.of(context).textTheme.bodySmall);
    if (row.control == SettingControl.toggle) {
      return SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(row.label), subtitle: subtitle, value: value == true, onChanged: save);
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(row.label),
      subtitle: subtitle,
      trailing: AppDropdown<String>(options: row.choices, value: '$value', onChanged: save),
    );
  }
}
