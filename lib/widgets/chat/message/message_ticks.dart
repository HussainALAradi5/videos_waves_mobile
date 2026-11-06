import 'package:flutter/material.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../enums/chat/message/read_state.dart';

/// One tick when sent, two when someone saw it, two in the brand colour when everyone read it.
class MessageTicks extends StatelessWidget {
  const MessageTicks({super.key, required this.state, required this.color});

  final ReadState state;

  /// The muted colour of the bubble's time text.
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = switch (state) {
      ReadState.sent => ChatMessages.tickSent,
      ReadState.seenBySome => ChatMessages.tickSeenBySome,
      ReadState.read => ChatMessages.tickRead,
    };
    final isRead = state == ReadState.read;
    return Tooltip(
      message: label,
      child: Icon(
        state == ReadState.sent ? Icons.done : Icons.done_all,
        size: 14,
        semanticLabel: label,
        color: isRead ? const Color(0xFF7CC4FF) : color,
      ),
    );
  }
}
