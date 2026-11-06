import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/common/ui_constants.dart';

/// Streams a video from its URL. The player is a media resource tied to this widget's lifetime,
/// so its controller is created and disposed here; app state stays in the screen's controllers.
class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key, required this.url, this.onFirstPlay});

  final String url;
  final VoidCallback? onFirstPlay;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late final VideoPlayerController _player = VideoPlayerController.networkUrl(Uri.parse(widget.url));
  late final Future<void> _initialized = _player.initialize();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_player.value.isPlaying) {
      _player.pause();
    } else {
      widget.onFirstPlay?.call();
      _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: Layout.videoAspectRatio,
      child: ColoredBox(
        color: AppColors.videoBackground,
        child: FutureBuilder<void>(
          future: _initialized,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) return const Center(child: Icon(Icons.videocam_off, color: AppColors.onVideoMuted));
            return GestureDetector(
              onTap: _togglePlay,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(child: AspectRatio(aspectRatio: _player.value.aspectRatio, child: VideoPlayer(_player))),
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: _player,
                    builder: (context, value, _) => value.isPlaying
                        ? const SizedBox.shrink()
                        : const Icon(Icons.play_circle_fill, size: Spacing.xl * 2, color: AppColors.onVideo),
                  ),
                  Align(alignment: Alignment.bottomCenter, child: VideoProgressIndicator(_player, allowScrubbing: true)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
