import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/common/gradients_constants.dart';
import '../../../constants/videos/video/video_preview_constants.dart';

/// A still preview for a feed card: the thumbnail when the CDN made one, otherwise a frame one second in
/// (loaded paused and muted, like the web card). The brand gradient shows while it loads or fails.
class VideoPreview extends StatefulWidget {
  const VideoPreview({super.key, required this.videoUrl, this.thumbnailUrl});

  final String videoUrl;
  final String? thumbnailUrl;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  static const Widget _placeholder = DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.brand));

  VideoPlayerController? _player;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.thumbnailUrl == null) _loadFirstFrame();
  }

  Future<void> _loadFirstFrame() async {
    final player = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _player = player;
    try {
      await player.initialize();
      await player.setVolume(0);
      await player.seekTo(VideoPreviewFrame.position);
      if (mounted) setState(() => _isReady = true);
    } catch (_) {
      // A broken or blocked file keeps the gradient placeholder.
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail = widget.thumbnailUrl;
    if (thumbnail != null) return Image.network(thumbnail, fit: BoxFit.cover, errorBuilder: (_, _, _) => _placeholder);
    final player = _player;
    if (!_isReady || player == null) return _placeholder;
    // A still preview never takes taps itself: the card or tile around it opens the video.
    return IgnorePointer(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(width: player.value.size.width, height: player.value.size.height, child: VideoPlayer(player)),
      ),
    );
  }
}
