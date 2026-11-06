import 'package:flutter/material.dart';

import '../../../constants/common/gradients_constants.dart';
import '../../../constants/common/messages_constants.dart';
import '../waves/wave_mark.dart';

/// The rolling wave mark and "Videos Waves" in the brand gradient.
class BrandTitle extends StatelessWidget {
  const BrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      const WaveMark(),
      const SizedBox(width: 10),
      ShaderMask(
        shaderCallback: AppGradients.brand.createShader,
        child: Text(
          AppMessages.appName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
    ]);
  }
}
