import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/enums/chat/conversation/member_role.dart';
import 'package:videos_waves_mobile/enums/chat/message/message_kind.dart';
import 'package:videos_waves_mobile/models/chat/conversation/chat_member.dart';
import 'package:videos_waves_mobile/models/chat/message/message.dart';
import 'package:videos_waves_mobile/models/users/user/public_user.dart';
import 'package:videos_waves_mobile/utilities/chat/conversation_utility.dart';
import 'package:videos_waves_mobile/utilities/format/media_format_utility.dart';

void main() {
  test('counts members who read at or after the message, ignoring hidden read times', () {
    final sent = Message(
      id: 'm1',
      conversationId: 'c1',
      sender: const PublicUser(id: 'me', userName: 'me'),
      kind: MessageKind.text,
      attachments: const [],
      reactions: const [],
      isEdited: false,
      isUnsent: false,
      createdAt: DateTime.utc(2026, 11, 6, 10),
    );
    ChatMember member(DateTime? readAt) =>
        ChatMember(user: const PublicUser(id: 'x', userName: 'x'), role: MemberRole.member, lastReadAt: readAt);
    expect(countSeenBy(sent, [member(DateTime.utc(2026, 11, 6, 10)), member(DateTime.utc(2026, 11, 6, 9)), member(null)]), 1);
  });

  test('formats durations and file sizes', () {
    expect(formatDuration(75.4), '1:15');
    expect(formatDuration(null), '');
    expect(formatFileSize(512), '512 B');
    expect(formatFileSize(1536), '1.5 KB');
    expect(formatFileSize(25 * 1024 * 1024), '25 MB');
  });
}
