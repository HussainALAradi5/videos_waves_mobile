import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/constants/chat/chat_messages_constants.dart';
import 'package:videos_waves_mobile/controllers/common/toast_controller.dart';
import 'package:videos_waves_mobile/enums/chat/conversation/member_role.dart';
import 'package:videos_waves_mobile/enums/chat/message/message_kind.dart';
import 'package:videos_waves_mobile/enums/chat/message/read_state.dart';
import 'package:videos_waves_mobile/enums/chat/realtime/presence_state.dart';
import 'package:videos_waves_mobile/enums/common/toast_type.dart';
import 'package:videos_waves_mobile/enums/users/settings/bubble_color.dart';
import 'package:videos_waves_mobile/enums/users/settings/bubble_style.dart';
import 'package:videos_waves_mobile/models/chat/conversation/chat_member.dart';
import 'package:videos_waves_mobile/models/chat/message/message.dart';
import 'package:videos_waves_mobile/models/users/user/public_user.dart';
import 'package:videos_waves_mobile/utilities/chat/bubble_look_utility.dart';
import 'package:videos_waves_mobile/utilities/chat/conversation_utility.dart';

void main() {
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
  ChatMember member(DateTime? readAt, {PresenceState? presence, String? statusText}) => ChatMember(
        user: const PublicUser(id: 'x', userName: 'x'),
        role: MemberRole.member,
        lastReadAt: readAt,
        presence: presence,
        statusText: statusText,
      );

  test('ticks: sent until anyone reads, seen by some in a group, read when everyone did', () {
    expect(readStateOf(sent, [member(null)]), ReadState.sent);
    expect(readStateOf(sent, [member(DateTime.utc(2026, 11, 6, 11)), member(null)]), ReadState.seenBySome);
    expect(readStateOf(sent, [member(DateTime.utc(2026, 11, 6, 11)), member(DateTime.utc(2026, 11, 6, 10))]), ReadState.read);
  });

  test('status line joins the status and the custom text, and hides offline', () {
    const labels = ChatMessages.presenceLabels;
    expect(describePresence(member(null, presence: PresenceState.busy, statusText: 'In a meeting'), labels), 'Busy · In a meeting');
    expect(describePresence(member(null, presence: PresenceState.offline, statusText: 'Back at 3'), labels), 'Back at 3');
    expect(describePresence(member(null), labels), isNull);
  });

  test('bubble look: gradient for my colour, theme surface for neutral, outline when minimal', () {
    final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    ({BoxDecoration decoration, Color foreground}) look({bool isMine = true, BubbleStyle style = BubbleStyle.rounded}) =>
        bubbleLook(scheme: scheme, isMine: isMine, isUnsent: false, style: style, myColor: BubbleColor.forest, othersColor: BubbleColor.neutral);
    expect(look().decoration.gradient, isNotNull);
    expect(look().foreground, Colors.white);
    expect(look(isMine: false).decoration.color, scheme.surfaceContainerHighest);
    expect(look(isMine: false, style: BubbleStyle.minimal).decoration.border, isNotNull);
    expect(bubbleRadii(BubbleStyle.square).big, lessThan(bubbleRadii(BubbleStyle.rounded).big));
  });

  test('toast queue shows at most three at once and dismisses by id', () {
    final toasts = ToastController();
    final ids = [for (var index = 0; index < 5; index++) toasts.show(ToastType.info, 't$index')];
    expect(toasts.visible.map((item) => item.message), ['t0', 't1', 't2']);
    toasts.dismiss(ids.first);
    expect(toasts.visible.map((item) => item.message), ['t1', 't2', 't3']);
  });
}
