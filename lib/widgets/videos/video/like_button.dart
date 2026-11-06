import 'package:flutter/material.dart';

import '../../../constants/common/ui_constants.dart';
import '../../../models/videos/video/video.dart';
import '../../../utilities/format/formatters.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({super.key, required this.video, required this.onPressed, this.isBusy = false});

  final Video video;
  final VoidCallback onPressed;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(video.isLiked ? Icons.favorite : Icons.favorite_border, color: video.isLiked ? AppColors.like : null);
    return OutlinedButton.icon(
      onPressed: isBusy ? null : onPressed,
      icon: icon,
      label: Text(formatCount(video.likesCount)),
    );
  }
}
