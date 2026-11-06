import 'package:flutter/material.dart';

import '../waves/wave_loader.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: WaveLoader(size: 36));
}
