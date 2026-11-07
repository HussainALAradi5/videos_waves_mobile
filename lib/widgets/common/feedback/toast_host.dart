import 'package:flutter/material.dart';

import 'toast_overlay.dart';

/// Draws the toasts above every screen and sheet. Nothing in a toast may need an Overlay (no
/// tooltips): this layer sits above the navigator, where there is none.
class ToastHost extends StatelessWidget {
  const ToastHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(children: [child, const ToastOverlay()]);
}
