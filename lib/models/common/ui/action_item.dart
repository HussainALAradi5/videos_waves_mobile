import 'package:flutter/material.dart';

/// One entry of the three-dots action sheet.
class ActionItem {
  const ActionItem({required this.label, required this.icon, required this.onSelected, this.isDanger = false});

  final String label;
  final IconData icon;
  final VoidCallback onSelected;

  /// Destructive entries are red and listed last.
  final bool isDanger;
}
