import 'package:flutter/material.dart';

import '../../../constants/common/app_colors_constants.dart';
import '../../../constants/common/gradients_constants.dart';
import '../../../constants/common/radii_constants.dart';
import '../../../enums/common/button_tone.dart';

/// The app button. While its action runs it shows a spinner and ignores taps, so nothing is sent twice.
class AppButton extends StatefulWidget {
  const AppButton({super.key, required this.label, required this.onPressed, this.tone = ButtonTone.gradient, this.icon, this.isLoading = false});

  final String label;

  /// May return a Future; the button stays busy until it completes.
  final Future<void> Function()? onPressed;
  final ButtonTone tone;
  final IconData? icon;
  final bool isLoading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isRunning = false;

  bool get _isBusy => _isRunning || widget.isLoading;

  Future<void> _run() async {
    if (_isBusy || widget.onPressed == null) return;
    setState(() => _isRunning = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) setState(() => _isRunning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isGradient = widget.tone == ButtonTone.gradient;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = switch (widget.tone) {
      ButtonTone.gradient || ButtonTone.primary || ButtonTone.danger => Colors.white,
      ButtonTone.dangerSoft => isDark ? AppColors.dangerSoftDark : AppColors.danger,
      _ => scheme.onSurface,
    };
    final background = switch (widget.tone) {
      ButtonTone.primary => AppColors.brandStart,
      ButtonTone.danger => AppColors.danger,
      ButtonTone.dangerSoft => AppColors.danger.withValues(alpha: isDark ? 0.18 : 0.10),
      ButtonTone.secondary => scheme.surfaceContainerHighest,
      _ => Colors.transparent,
    };
    final child = AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      child: _isBusy
          ? SizedBox(key: const ValueKey('busy'), width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: foreground))
          : Row(key: const ValueKey('idle'), mainAxisSize: MainAxisSize.min, children: [
              if (widget.icon != null) ...[Icon(widget.icon, size: 18, color: foreground), const SizedBox(width: 8)],
              Text(widget.label, style: TextStyle(color: foreground, fontWeight: FontWeight.w600)),
            ]),
    );
    return Opacity(
      opacity: widget.onPressed == null ? 0.5 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isGradient ? AppGradients.brand : null,
          color: isGradient ? null : background,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: widget.tone == ButtonTone.outline ? Border.all(color: scheme.outlineVariant) : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(Radii.pill),
            onTap: _isBusy ? null : _run,
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Center(widthFactor: 1, child: child)),
          ),
        ),
      ),
    );
  }
}
