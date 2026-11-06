import 'package:flutter/material.dart';

import '../../../constants/common/gradients_constants.dart';

/// Round gradient send or record button with a spinner while busy.
class SendButton extends StatelessWidget {
  const SendButton({super.key, required this.isBusy, required this.icon, required this.tooltip, required this.onPressed});

  final bool isBusy;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: isBusy ? null : onPressed,
        child: Ink(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(gradient: AppGradients.brand, shape: BoxShape.circle),
          child: Center(
            child: isBusy
                ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
