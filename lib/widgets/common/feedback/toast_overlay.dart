import 'package:flutter/material.dart';

import '../../../globals/app_toasts.dart';
import 'toast_card.dart';

/// Shows the toast queue at the top of every screen (placed above the router in the app builder).
class ToastOverlay extends StatelessWidget {
  const ToastOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appToasts,
      builder: (context, _) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                for (final item in appToasts.visible) Padding(padding: const EdgeInsets.only(bottom: 8), child: ToastCard(key: ValueKey(item.id), item: item)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
