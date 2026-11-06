import '../../../enums/users/settings/setting_control.dart';
import '../../common/ui/dropdown_option.dart';

/// One preference row; the settings screen is rendered from a table of these.
class SettingRow {
  const SettingRow({
    required this.key,
    required this.label,
    required this.description,
    required this.control,
    this.choices = const [],
    this.maxLength,
    this.hint,
  });

  /// The settings key sent to the server.
  final String key;
  final String label;
  final String description;
  final SettingControl control;
  final List<DropdownOption<String>> choices;

  /// Text rows: the longest value and the hint inside the box.
  final int? maxLength;
  final String? hint;
}

class SettingSection {
  const SettingSection({required this.title, required this.rows, this.showsBubblePreview = false});

  final String title;
  final List<SettingRow> rows;

  /// A live two-bubble sample under the rows (the Chats section).
  final bool showsBubblePreview;
}
