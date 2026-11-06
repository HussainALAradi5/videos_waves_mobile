import '../../enums/chat/realtime/presence_state.dart';

class ChatMessages {
  const ChatMessages._();

  static const String title = 'Messages';
  static const String inbox = 'Inbox';
  static const String all = 'All';
  static const String read = 'Read';
  static const String tickSent = 'Sent';
  static const String tickSeenBySome = 'Seen by some';
  static const String tickRead = 'Read';
  static const String background = 'Chat background';
  static const String backgroundHint = 'Only you see this, and only in this chat.';
  static const String backgroundSaved = 'Background updated';
  static const String statusPicker = 'Your status';
  static const Map<PresenceState, String> presenceLabels = {
    PresenceState.online: 'Online',
    PresenceState.away: 'Away',
    PresenceState.busy: 'Busy',
    PresenceState.offline: 'Offline',
  };
  static String newMessageFrom(String name) => 'New message from $name';
  static const String attachmentPreview = 'Sent an attachment';
  static const String requests = 'Requests';
  static const String groups = 'Groups';
  static const String unread = 'Unread';
  static const String newMessage = 'New message';
  static const String pickPeople = 'Pick people to message';
  static const String start = 'Chat';
  static const String groupName = 'Group name';
  static const String createGroup = 'Create group';
  static const String noChats = 'No messages yet';
  static const String noChatsHint = 'Start a conversation from someone\'s profile or the + button.';
  static const String messageHint = 'Message...';
  static const String online = 'Active now';
  static const String typing = 'typing...';
  static const String seen = 'Seen';
  static const String edited = 'Edited';
  static const String unsent = 'Message unsent';
  static const String reply = 'Reply';
  static const String copy = 'Copy';
  static const String edit = 'Edit';
  static const String unsend = 'Unsend';
  static const String deleteForMe = 'Delete for me';
  static const String copied = 'Copied';
  static const String editMessage = 'Edit message';
  static const String requestTitle = 'Message request';
  static const String requestBody = 'They can\'t see that you\'ve read their messages until you accept.';
  static const String accept = 'Accept';
  static const String delete = 'Delete';
  static const String attach = 'Add photos, videos, or files';
  static const String record = 'Record a voice note';
  static const String stopRecording = 'Send voice note';
  static const String cancelRecording = 'Cancel';
  static const String micDenied = 'Microphone access is needed for voice notes.';
  static const String tooManyFiles = 'Up to 10 files per message.';
  static const String sharedVideo = 'Shared a video';
  static String seenBy(int count) => 'Seen by $count';
  static String replyingTo(String userName) => 'Replying to $userName';
  static String members(int count) => '$count members';
  static String system(String? action, String sender, String? target, String? body) => switch (action) {
        'group_created' => '$sender created the group',
        'member_added' => '$sender added ${target ?? 'someone'}',
        'member_removed' => '$sender removed ${target ?? 'someone'}',
        'member_left' => '$sender left',
        'group_renamed' => '$sender renamed the group${body == null ? '' : ' to $body'}',
        'admin_granted' => '$sender made ${target ?? 'someone'} an admin',
        'admin_revoked' => '$sender removed ${target ?? 'someone'} as admin',
        _ => body ?? '',
      };
}
