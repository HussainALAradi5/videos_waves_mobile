import '../../../enums/users/settings/setting_control.dart';
import '../../common/ui/dropdown_option.dart';

/// One preference row; the settings screen is rendered from a table of these.
class SettingRow {
  const SettingRow({required this.key, required this.label, required this.description, required this.control, this.choices = const []});

  /// The settings key sent to the server.
  final String key;
  final String label;
  final String description;
  final SettingControl control;
  final List<DropdownOption<String>> choices;
}

class SettingSection {
  const SettingSection({required this.title, required this.rows});

  final String title;
  final List<SettingRow> rows;
}
