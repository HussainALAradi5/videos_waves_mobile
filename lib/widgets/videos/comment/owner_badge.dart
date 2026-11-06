import 'package:flutter/material.dart';

import '../../../constants/common/gradients_constants.dart';
import '../../../constants/common/radii_constants.dart';

const String _ownerLabel = 'Owner';

/// Marks comments written by the person who posted the video.
class OwnerBadge extends StatelessWidget {
  const OwnerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(gradient: AppGradients.brand, borderRadius: BorderRadius.circular(Radii.pill)),
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.verified, size: 12, color: Colors.white),
        SizedBox(width: 3),
        Text(_ownerLabel, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
