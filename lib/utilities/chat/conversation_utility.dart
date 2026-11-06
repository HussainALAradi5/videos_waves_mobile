import '../../models/chat/conversation/chat_member.dart';
import '../../models/chat/conversation/conversation.dart';
import '../../models/chat/message/message.dart';

/// Members (everyone except me) who have read up to [message]; restricted read times arrive as null.
int countSeenBy(Message message, List<ChatMember> members) =>
    members.where((member) => member.lastReadAt != null && !member.lastReadAt!.isBefore(message.createdAt)).length;

bool isPartnerOnline(Conversation conversation) => conversation.members.any((member) => member.isOnline == true);
