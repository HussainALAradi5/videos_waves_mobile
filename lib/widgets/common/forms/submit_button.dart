import 'package:flutter/material.dart';

import '../../../constants/common/gradients_constants.dart';
import '../../../constants/common/ui_constants.dart';

/// The main button of a form (Sign in, Create account): full width, in the brand gradient like the
/// other primary buttons, with a spinner while it works.
class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.label, required this.onPressed, this.isLoading = false});

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  static const double _spinnerSize = Spacing.md + Spacing.xs;
  static const double _height = Spacing.xl + Spacing.md;

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isLoading && onPressed != null;
    return Opacity(
      opacity: isEnabled || isLoading ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: AppGradients.brand, borderRadius: BorderRadius.circular(Radii.pill)),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: isEnabled ? onPressed : null,
            child: SizedBox(
              height: _height,
              child: Center(
                child: isLoading
                    ? const SizedBox.square(dimension: _spinnerSize, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
