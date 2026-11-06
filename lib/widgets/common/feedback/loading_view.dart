import 'package:flutter/material.dart';

import '../../../constants/common/ui_constants.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(padding: EdgeInsets.all(Spacing.xl), child: CircularProgressIndicator()),
    );
  }
}
