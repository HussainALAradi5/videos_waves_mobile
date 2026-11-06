import '../../enums/chat/message/read_state.dart';
import '../../enums/chat/realtime/presence_state.dart';
import '../../models/chat/conversation/chat_member.dart';
import '../../models/chat/message/message.dart';

/// Members (everyone except me) who have read up to [message]; restricted read times arrive as null.
int countSeenBy(Message message, List<ChatMember> members) =>
    members.where((member) => member.lastReadAt != null && !member.lastReadAt!.isBefore(message.createdAt)).length;


/// ✓ sent, ✓✓ seen by some of a group, ✓✓ in the brand colour when everyone read it.
ReadState readStateOf(Message message, List<ChatMember> members) {
  final seen = countSeenBy(message, members);
  if (seen == 0 || members.isEmpty) return ReadState.sent;
  return seen >= members.length ? ReadState.read : ReadState.seenBySome;
}

/// "Online · In a meeting", "Busy", or just the custom line while offline; null when nothing is shown.
String? describePresence(ChatMember member, Map<PresenceState, String> labels) {
  final presence = member.presence;
  final state = presence != null && presence != PresenceState.offline ? labels[presence] : null;
  final parts = [?state, if ((member.statusText ?? '').isNotEmpty) member.statusText!];
  return parts.isEmpty ? null : parts.join(' · ');
}
