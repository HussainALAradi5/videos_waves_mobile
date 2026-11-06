import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../utilities/format/media_format_utility.dart';

/// Play and pause a voice note with its progress.
class VoiceNotePlayer extends StatefulWidget {
  const VoiceNotePlayer({super.key, required this.url, required this.color});

  final String url;
  final Color color;

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _isLoaded = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (!_isLoaded) {
      await _player.setUrl(widget.url);
      _isLoaded = true;
    }
    if (_player.playing) return _player.pause();
    if (_player.processingState == ProcessingState.completed) await _player.seek(Duration.zero);
    await _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, state) => Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          icon: Icon(state.data?.playing == true ? Icons.pause_circle : Icons.play_circle, color: widget.color, size: 32),
          onPressed: _toggle,
        ),
        StreamBuilder<Duration>(
          stream: _player.positionStream,
          builder: (context, position) {
            final total = _player.duration ?? Duration.zero;
            final value = total.inMilliseconds == 0 ? 0.0 : (position.data ?? Duration.zero).inMilliseconds / total.inMilliseconds;
            return Row(children: [
              SizedBox(width: 110, child: LinearProgressIndicator(value: value.clamp(0, 1), color: widget.color, backgroundColor: widget.color.withValues(alpha: 0.3))),
              const SizedBox(width: 8),
              Text(formatClockDuration(total), style: TextStyle(color: widget.color, fontSize: 12)),
            ]);
          },
        ),
      ]),
    );
  }
}
