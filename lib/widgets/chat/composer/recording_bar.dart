import 'package:flutter/material.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../utilities/format/media_format_utility.dart';
import '../../common/waves/wave_loader.dart';

/// Shown while recording: a pulsing wave, the timer, Cancel, and Send.
class RecordingBar extends StatelessWidget {
  const RecordingBar({super.key, required this.elapsed, required this.onCancel, required this.onSend});

  final Duration elapsed;
  final Future<void> Function() onCancel;
  final Future<void> Function() onSend;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      TextButton(onPressed: onCancel, child: const Text(ChatMessages.cancelRecording)),
      const Icon(Icons.fiber_manual_record, color: Colors.red, size: 14),
      const SizedBox(width: 6),
      Text(formatClockDuration(elapsed)),
      const Spacer(),
      const WaveLoader(size: 22),
      const Spacer(),
      IconButton.filled(tooltip: ChatMessages.stopRecording, icon: const Icon(Icons.send_rounded), onPressed: onSend),
    ]);
  }
}
