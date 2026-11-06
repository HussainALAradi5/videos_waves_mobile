import 'package:flutter/material.dart';

import '../../../constants/common/radii_constants.dart';
import '../../../models/media/media/media.dart';
import '../../videos/video/video_player_view.dart';

/// Photos in a grid; videos and files as tiles (videos open in a player).
class MessageAttachments extends StatelessWidget {
  const MessageAttachments({super.key, required this.attachments, required this.color});

  final List<Media> attachments;
  final Color color;

  void _openVideo(BuildContext context, Media media) => showDialog<void>(
        context: context,
        builder: (_) => Dialog(clipBehavior: Clip.antiAlias, child: VideoPlayerView(url: media.url)),
      );

  @override
  Widget build(BuildContext context) {
    final images = attachments.where((media) => media.mimeType.startsWith('image/')).toList();
    final others = attachments.where((media) => !media.mimeType.startsWith('image/')).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (images.isNotEmpty)
        Wrap(spacing: 4, runSpacing: 4, children: [
          for (final media in images)
            ClipRRect(
              borderRadius: BorderRadius.circular(Radii.md),
              child: Image.network(media.url, width: images.length == 1 ? 220 : 108, height: images.length == 1 ? 220 : 108, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(width: 108, height: 108, child: Icon(Icons.broken_image_outlined))),
            ),
        ]),
      for (final media in others)
        InkWell(
          onTap: media.mimeType.startsWith('video/') ? () => _openVideo(context, media) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(media.mimeType.startsWith('video/') ? Icons.play_circle_outline : Icons.description_outlined, color: color),
              const SizedBox(width: 6),
              Flexible(child: Text(media.originalName, style: TextStyle(color: color, decoration: TextDecoration.underline), overflow: TextOverflow.ellipsis)),
            ]),
          ),
        ),
    ]);
  }
}
