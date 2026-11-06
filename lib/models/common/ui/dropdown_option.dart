import 'package:flutter/widgets.dart';

import 'status_option.dart';

/// One choice in an AppDropdown or MultiSelectSheet.
class DropdownOption<T> {
  const DropdownOption({required this.value, required this.label, this.leading, this.badge});

  final T value;
  final String label;
  final Widget? leading;

  /// Shows the label as a coloured badge, matching the badges in lists (roles, statuses).
  final StatusOption? badge;
}
