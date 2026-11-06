import 'package:flutter/material.dart';

import '../../../constants/common/ui_constants.dart';

/// Centers content with a readable maximum width on tablets and large screens.
class ConstrainedContent extends StatelessWidget {
  const ConstrainedContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: Layout.maxContentWidth), child: child),
    );
  }
}
