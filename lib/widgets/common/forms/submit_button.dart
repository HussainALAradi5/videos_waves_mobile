import 'package:flutter/material.dart';

import '../../../constants/common/ui_constants.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.label, required this.onPressed, this.isLoading = false});

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  static const double _spinnerSize = Spacing.md + Spacing.xs;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(Spacing.xl + Spacing.md)),
      child: isLoading
          ? const SizedBox.square(dimension: _spinnerSize, child: CircularProgressIndicator(strokeWidth: 2))
          : Text(label),
    );
  }
}
