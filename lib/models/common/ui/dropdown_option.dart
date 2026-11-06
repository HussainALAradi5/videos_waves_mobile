import 'package:flutter/widgets.dart';

/// One choice in an AppDropdown or MultiSelectSheet.
class DropdownOption<T> {
  const DropdownOption({required this.value, required this.label, this.leading});

  final T value;
  final String label;
  final Widget? leading;
}
